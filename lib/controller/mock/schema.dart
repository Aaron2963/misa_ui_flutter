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
    "ISBN": {"type": "string", "title": "ISBN", "component": "editbox"},
    "Name": {
      "type": "string",
      "title": "Textbook Name",
      "component": "editbox",
      "purpose": ["header"]
    },
    "_TextbookTYPName": {
      "type": "string",
      "title": "Textbook Type",
      "component": "editbox",
      "readonly": true,
      "purpose": ["header"]
    },
    "TextbookTYPID": {
      "type": "string",
      "title": "Textbook Type",
      "component": "select",
      "formOnly": true,
      "@chain": [
        {
          "type": "object",
          "@id": "TextbookTYPID",
          "@table": "TextbookTYP:Brief",
          "properties": {
            "TextbookTYPID": {
              "type": "string",
              "component": "editbox",
              "readonly": true
            },
            "Name": {
              "type": "string",
              "component": "editbox",
              "purpose": "caption",
              "readonly": true
            }
          }
        }
      ]
    },
    "EDTDCP": {
      "type": "string",
      "title": "Description",
      "component": "editbox"
    },
    "Keyword": {
      "type": "string",
      "title": "Keyword",
      "component": "editbox",
      "purpose": ["header"]
    },
    "Author": {
      "type": "string",
      "title": "Author",
      "component": "editbox",
      "purpose": ["header"]
    },
    "Translator": {
      "type": "string",
      "title": "Translator",
      "component": "editbox"
    },
    "Brief": {
      "type": "string",
      "title": "Textbook Intro",
      "component": "textarea"
    },
    "Detail": {
      "type": "string",
      "title": "Detail",
      "component": "richtext",
      "richtextStyles": ["../plugins/bootstrap/css/bootstrap.min.css"]
    },
    "_Pictures": {
      "type": "array",
      "title": "Pictures",
      "items": {
        "type": "object",
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
    "_UploadFiles": {
      "type": "array",
      "title": "Files",
      "items": {
        "type": "object",
        "properties": {
          "_FileBinary": {
            "type": "string",
            "title": "File",
            "component": "file"
          },
          "_FileTitle": {
            "type": "string",
            "title": "File Title",
            "component": "editbox"
          },
          "_FileAlt": {
            "type": "string",
            "title": "File Alt",
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
  "filter": ["TextbookID", "SERNO", "ISBN", "Name", "EDTDCP", "Keyword"],
  "@id": "TextbookID",
  "dependentRequired": {
    "insert": ["SERNO", "Name", "TextbookTYPID"],
    "edit": ["SERNO", "Name", "TextbookTYPID"]
  }
};
