final Map<String, dynamic> mockSchema = {
  "\$schema": "http://json-schema.org/draft-06/schema#",
  "title": "Textbook Info",
  "@table": "Textbook",
  "type": "object",
  "properties": {
    "TextbookID": {
      "type": "string",
      "component": "hidden",
      "formOnly": true,
      "readonly": true
    },
    "SERNO": {
      "type": "string",
      "title": "Textbook No.",
      "component": "editbox",
      "purpose": ["header", "caption"]
    },
    "Name": {
      "type": "string",
      "title": "Textbook Name",
      "component": "editbox",
      "purpose": ["header"]
    },
    "_Editors": {
      "type": "object",
      "title": "Editors",
      "properties": {
        "_AuthorName": {
          "type": "string",
          "title": "Author",
          "component": "editbox",
        },
        "_TranslatorName": {
          "type": "string",
          "title": "Translator",
          "component": "editbox",
        },
        "_EditorName": {
          "type": "string",
          "title": "Editor",
          "component": "editbox",
        },
        "_AuditorName": {
          "type": "string",
          "title": "Auditor",
          "component": "editbox",
        },
      }
    },
    "_Pictures": {
      "type": "array",
      "title": "Pictures",
      "items": {
        "type": "object",
        "title": "",
        "properties": {
          "_PictureFile": {
            "type": "string",
            "title": "Picture File",
            "component": "image"
          },
          "_PictureTitle": {
            "type": "string",
            "title": "Picture Title",
            "component": "editbox"
          },
          "_PictureAlt": {
            "type": "string",
            "title": "Picture Alt",
            "component": "editbox"
          }
        }
      }
    },
    "ORIPublishDateTime": {
      "type": "string",
      "title": "Publish Date",
      "component": "date",
      "purpose": ["header"]
    }
  },
  "filter": [
    "TextbookID",
    "SERNO",
    "Name",
    "ORIPublishDateTime"
  ],
  "@id": "TextbookID",
  "dependentRequired": {
    "insert": ["SERNO", "Name"],
    "edit": ["SERNO", "Name"]
  }
};
