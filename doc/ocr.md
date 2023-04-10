# Optical Character Recognition

```bash
gcloud init --no-launch-browser

# detect-text and detect-document give similar results
# data["responses"][1]["fullTextAnnotation"]["text"] is the concateated field
gcloud ml vision detect-text https://web.corral.tacc.utexas.edu/UAF/ala/2014_01_31/jpg/H1276099.jpg > H1276099.json
gcloud ml vision detect-document https://web.corral.tacc.utexas.edu/UAF/ala/2014
_01_31/jpg/H1276099.jpg > tmp/H1276099b.json

gcloud alpha ml translate translate-text --content="Биоценология (от биоценоз и греч. λόγος — слово, учение, наука)" --source-language=ru --target-language=en --format=json

