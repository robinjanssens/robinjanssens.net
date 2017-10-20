import json
import codecs
import markdown

# Read JSON file
with open('./content.json') as data_file:
    data = json.load(data_file)

# Generate html pages
for page in data['pages']:
    inputFile = codecs.open(page['src'], mode='r', encoding='utf-8')
    content = inputFile.read()
    if page['type'] == 'markdown':
        html = markdown.markdown(content)
    elif page['type'] == 'html':
        html = content
    else:
        print('unknown type ' + page['title'])
        continue   # skip this page
    outputFilePath = 'public/' + page['src'].split('/')[-1].split('.')[0] + '.html'   # 'public/' + last element of source pad + remove extension + add '.html'
    outputFile = codecs.open(outputFilePath, 'w', encoding='utf-8', errors='xmlcharrefreplace')
    outputFile.write(html)
