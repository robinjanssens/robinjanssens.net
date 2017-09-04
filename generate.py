import codecs
import markdown
input_file = codecs.open("wishlist.md", mode="r", encoding="utf-8")
text = input_file.read()
html = markdown.markdown(text)
output_file = codecs.open("wishlist.html", "w", encoding="utf-8", errors="xmlcharrefreplace")
output_file.write(html)