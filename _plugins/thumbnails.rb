# frozen_string_literal: true

# Generates the AVIF / WebP / JPEG derivatives that the <picture> elements on the site expect.
#
# Sources live in _originals/images/ (full resolution, never published). For each source this
# writes assets/images/<name>.{avif,webp,jpg}, skipping any derivative that is already newer than
# its source — so a rebuild with nothing changed costs one stat() per file and no encoding.
#
# Runs on `jekyll build` and on every `jekyll serve` rebuild. If ImageMagick is not installed the
# build continues with a warning: the derivatives are committed to the repo, so a machine without
# ImageMagick can still build the site, it just cannot add new images.
#
# Settings below are the single source of truth. See README.md for installing ImageMagick.
module Thumbnails
  SOURCE_DIR = "_originals/images"
  OUTPUT_DIR = "assets/images"

  # Fits inside this box, never upscales (that is what ">" means). Cards display at 22em ~ 352px,
  # so 800 still covers 2x DPI screens.
  RESIZE = "800x800>"

  # Applied to every variant. -auto-orient must come before -strip, or EXIF rotation is discarded
  # before it has been baked into the pixels and phone photos end up sideways.
  COMMON_ARGS = %w[-auto-orient -strip -colorspace sRGB].freeze

  # Quality values were chosen by measuring PSNR against a lossless reference; all land in the
  # 33-39 dB band, visually transparent at display size. AVIF's scale is not comparable to
  # JPEG's -- 55 is roughly equivalent to JPEG 82.
  VARIANTS = {
    "jpg"  => %w[-quality 82 -sampling-factor 4:2:0 -interlace JPEG],
    "webp" => %w[-quality 80 -define webp:method=6],
    "avif" => %w[-quality 55]
  }.freeze

  SOURCE_EXTENSIONS = %w[.jpg .jpeg .png .tif .tiff .heic .heif .webp .avif].freeze

  LOG_TOPIC = "Thumbnails:"

  class << self
    def generate(site)
      source_dir = File.join(site.source, SOURCE_DIR)
      return unless Dir.exist?(source_dir)

      sources = Dir.children(source_dir)
                   .select { |f| SOURCE_EXTENSIONS.include?(File.extname(f).downcase) }
                   .sort
                   .map { |f| File.join(source_dir, f) }
      return if sources.empty?

      output_dir = File.join(site.source, OUTPUT_DIR)
      FileUtils.mkdir_p(output_dir)

      generated = 0
      sources.each { |src| generated += process(src, output_dir) }

      Jekyll.logger.info LOG_TOPIC, "#{generated} file(s) generated" if generated.positive?
    end

    private

    def process(source, output_dir)
      name = File.basename(source, ".*")

      # The template derives sibling paths with `split: "."`, so a dot in the name would break it.
      if name.include?(".")
        Jekyll.logger.warn LOG_TOPIC, "skipping #{File.basename(source)}: name must not contain a dot"
        return 0
      end

      stale = VARIANTS.keys.reject { |ext| current?(File.join(output_dir, "#{name}.#{ext}"), source) }
      return 0 if stale.empty?
      return 0 unless magick_available?

      # Clean the source before encoding, so the derivatives come from the stripped file. This
      # bumps the source mtime, so everything is re-encoded rather than leaving some variants
      # older than their source and regenerating them on the next build.
      stale = VARIANTS.keys if strip_source!(source)

      generated = 0
      stale.each do |extension|
        target = File.join(output_dir, "#{name}.#{extension}")

        if run(["magick", source, *COMMON_ARGS, "-resize", RESIZE, *VARIANTS[extension], target])
          generated += 1
          Jekyll.logger.info LOG_TOPIC, "wrote #{OUTPUT_DIR}/#{name}.#{extension} #{dimensions(target)}"
        else
          Jekyll.logger.error LOG_TOPIC, "failed to encode #{name}.#{extension}"
        end
      end

      if generated.positive?
        Jekyll.logger.info LOG_TOPIC,
                           "add width/height #{dimensions(File.join(output_dir, "#{name}.jpg"))} " \
                           "to the data entry for #{name}"
      end

      generated
    end

    def current?(target, source)
      File.exist?(target) && File.mtime(target) >= File.mtime(source)
    end

    # -strip cleans the derivatives, but the originals keep whatever the camera wrote -- including
    # GPS coordinates -- and _originals/ is committed to git, so the metadata would reach the
    # repository even though it never reaches the site.
    #
    # exiftool rewrites only the metadata segments and leaves the pixel data byte-identical.
    # Doing this with ImageMagick's -strip would re-encode and permanently degrade the archival
    # copy (measured: 1.4M pixels changed on a 900x600 test image).
    #
    # Orientation and the ICC profile are kept on purpose. Neither identifies anything, and
    # without them -auto-orient can no longer straighten a photo shot sideways and -colorspace
    # can no longer interpret a wide-gamut source. Re-running this is stable: stripping an
    # already-stripped file produces identical bytes.
    def strip_source!(source)
      return false unless exiftool_available?

      if run(["exiftool", "-all=", "-tagsfromfile", "@", "-Orientation", "-ICC_Profile",
              "-overwrite_original", "-q", "-q", source])
        Jekyll.logger.info LOG_TOPIC, "stripped metadata from #{SOURCE_DIR}/#{File.basename(source)}"
        true
      else
        Jekyll.logger.error LOG_TOPIC, "failed to strip metadata from #{File.basename(source)}"
        false
      end
    end

    # Reported once per build rather than once per missing file.
    def magick_available?
      return @magick_available unless @magick_available.nil?

      @magick_available = run(%w[magick -version])
      unless @magick_available
        Jekyll.logger.warn LOG_TOPIC, "ImageMagick not found, cannot generate images (see README.md)"
      end
      @magick_available
    end

    def exiftool_available?
      return @exiftool_available unless @exiftool_available.nil?

      @exiftool_available = run(%w[exiftool -ver])
      unless @exiftool_available
        Jekyll.logger.warn LOG_TOPIC,
                           "exiftool not found, originals keep their metadata (see README.md). " \
                           "Published images are still stripped."
      end
      @exiftool_available
    end

    # Array form, so filenames are passed as arguments and never interpreted by a shell.
    def run(command)
      system(*command, out: File::NULL, err: File::NULL)
    end

    def dimensions(file)
      return "" unless File.exist?(file)

      size = IO.popen(["magick", "identify", "-format", "%wx%h", file], &:read)
      $?&.success? ? "(#{size})" : ""
    end
  end
end

# :after_init fires before Jekyll reads the source tree, so anything written here is picked up
# and copied into _site by the same build.
Jekyll::Hooks.register :site, :after_init do |site|
  Thumbnails.generate(site)
end
