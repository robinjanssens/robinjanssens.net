import codecs
import markdown

inputFileName = "content/wishlist.md"
outputFileName = "public/wishlist.html"

inputFile = codecs.open(inputFileName, mode="r", encoding="utf-8")
text = inputFile.read()
html = markdown.markdown(text)
outputFile = codecs.open(outputFileName, "w", encoding="utf-8", errors="xmlcharrefreplace")
outputFile.write(html)
