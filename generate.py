import codecs
import markdown

inputFileName = "wishlist.md"
outputFileName = "wishlist.html"

inputFile = codecs.open(inputFileName, mode="r", encoding="utf-8")
text = inputFile.read()
html = markdown.markdown(text)
outputFile = codecs.open(outputFileName, "w", encoding="utf-8", errors="xmlcharrefreplace")
outputFile.write(html)
