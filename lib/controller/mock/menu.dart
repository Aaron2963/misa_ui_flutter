final Map<String, dynamic> mockMenu = {
  "Organization": {
    "icon": "sitemap",
    "items": {
      "Employee": {
        "views": [
          {
            "type": "List",
            "schema": {"\$ref": "../schema/vendor_ui/employee.json#"},
            "database": "misa",
            "component": [
              "Filter",
              "Pagination",
              "DetailModal",
              "Insert",
              "Edit",
              "SaveAsNew"
            ]
          }
        ]
      },
      "Site Settings": {
        "views": [
          {
            "type": "Detail",
            "schema": {"\$ref": "../schema/vendor_ui/site-settings.json#"},
            "database": "misa",
            "component": ["More", "Edit"]
          }
        ]
      },
      "Permission": {
        "views": [
          {
            "type": "List",
            "schema": {
              "\$ref": "../schema/vendor_ui/permission-schema-getter.php#"
            },
            "database": "misa",
            "component": [
              "Filter",
              "Pagination",
              "DetailModal",
              "Insert",
              "Edit",
              "SaveAsNew",
              "Delete"
            ]
          }
        ]
      }
    }
  },
  "Site": {
    "icon": "cloud",
    "items": {
      "Link": {
        "views": [
          {
            "type": "List",
            "schema": {"\$ref": "../schema/vendor_ui/link.json#"},
            "database": "misa",
            "component": [
              "Filter",
              "Pagination",
              "DetailModal",
              "Edit",
              "FormModal"
            ]
          }
        ]
      },
      "Document": {
        "views": [
          {
            "type": "List",
            "schema": {"\$ref": "../schema/vendor_ui/document.json#"},
            "database": "misa",
            "component": [
              "Filter",
              "Pagination",
              "DetailModal",
              "Insert",
              "Edit",
              "FormModal",
              "SaveAsNew",
              "Delete"
            ]
          }
        ]
      },
      "Document Type": {
        "views": [
          {
            "type": "List",
            "schema": {"\$ref": "../schema/vendor_ui/document-type.json#"},
            "database": "misa",
            "component": ["Filter", "Pagination", "DetailModal", "Edit"]
          }
        ]
      },
      "Site Settings": {
        "views": [
          {
            "type": "Detail",
            "schema": {"\$ref": "../schema/vendor_ui/site-settings.json#"},
            "database": "misa",
            "component": ["More", "Edit"]
          }
        ]
      }
    }
  },
  "View Schema": {
    "icon": "columns",
    "items": {
      "View Schema": {
        "views": [
          {
            "type": "List",
            "schema": {"\$ref": "../schema/vendor_ui/view-schema.json#"},
            "database": "misa",
            "component": [
              "Filter",
              "Pagination",
              "DetailModal",
              "Edit",
              "FormModal"
            ]
          }
        ]
      },
      "View Schema Type": {
        "views": [
          {
            "type": "List",
            "schema": {"\$ref": "../schema/vendor_ui/view-schema-type.json#"},
            "database": "misa",
            "component": ["Filter", "Pagination", "DetailModal", "Edit"]
          }
        ]
      },
      "Image": {
        "views": [
          {
            "type": "Album",
            "schema": {"\$ref": "../schema/vendor_ui/album.json#"},
            "database": "misa",
            "component": [
              "Filter",
              "Pagination",
              "DetailModal",
              "SelectAll",
              "Insert",
              "Delete"
            ]
          }
        ]
      }
    }
  },
  "Customer": {
    "icon": "handshake-o",
    "items": {
      "Customer Info": {
        "views": [
          {
            "type": "List",
            "schema": {"\$ref": "../schema/vendor_ui/customer.json#"},
            "database": "misa",
            "component": [
              "Filter",
              "Pagination",
              "DetailModal",
              "Insert",
              "Edit",
              "Delete",
              "SaveAsNew"
            ]
          }
        ]
      },
      "Customer Type": {
        "views": [
          {
            "type": "List",
            "schema": {"\$ref": "../schema/vendor_ui/customer-type.json#"},
            "database": "misa",
            "component": [
              "Filter",
              "Pagination",
              "Insert",
              "Edit",
              "DetailModal",
              "SaveAsNew",
              "Delete"
            ]
          }
        ]
      }
    }
  },
  "Customer with Deal Term": {
    "icon": "handshake-o",
    "items": {
      "Customer Info": {
        "views": [
          {
            "type": "List",
            "schema": {
              "\$ref": "../schema/vendor_ui/customer-with-deal-term.json#"
            },
            "database": "misa",
            "component": [
              "Filter",
              "Pagination",
              "DetailModal",
              "Insert",
              "Edit",
              "Delete",
              "SaveAsNew"
            ]
          }
        ]
      },
      "Customer Type": {
        "views": [
          {
            "type": "List",
            "schema": {"\$ref": "../schema/vendor_ui/customer-type.json#"},
            "database": "misa",
            "component": [
              "Filter",
              "Pagination",
              "Insert",
              "Edit",
              "DetailModal",
              "SaveAsNew",
              "Delete"
            ]
          }
        ]
      }
    }
  },
  "User": {
    "icon": "user",
    "items": {
      "Member": {
        "views": [
          {
            "type": "List",
            "schema": {"\$ref": "../schema/vendor_ui/member.json#"},
            "database": "misa",
            "component": [
              "Filter",
              "Pagination",
              "DetailModal",
              "Insert",
              "Edit",
              "SaveAsNew"
            ]
          }
        ]
      },
      "Member Type": {
        "views": [
          {
            "type": "List",
            "schema": {"\$ref": "../schema/vendor_ui/member-type.json#"},
            "database": "misa",
            "component": [
              "Filter",
              "Pagination",
              "Insert",
              "Edit",
              "DetailModal",
              "SaveAsNew",
              "Delete"
            ]
          }
        ]
      }
    }
  },
  "Counter": {
    "icon": "th-list",
    "items": {
      "Counter Info": {
        "views": [
          {
            "type": "List",
            "schema": {"\$ref": "../schema/vendor_ui/counter.json#"},
            "database": "misa",
            "component": [
              "Filter",
              "Pagination",
              "Insert",
              "Edit",
              "Delete",
              "DetailModal",
              "SaveAsNew"
            ]
          }
        ]
      },
      "Counter Type": {
        "views": [
          {
            "type": "List",
            "schema": {"\$ref": "../schema/vendor_ui/counter-type.json#"},
            "database": "misa",
            "component": [
              "Filter",
              "Pagination",
              "Insert",
              "Edit",
              "DetailModal",
              "SaveAsNew",
              "Delete"
            ]
          }
        ]
      },
      "Counter Product": {
        "views": [
          {
            "type": "QueryList",
            "schema": {"\$ref": "../schema/vendor_ui/counter-product.json#"},
            "database": "misa",
            "component": [
              "Filter",
              "Pagination",
              "DetailModal",
              "Insert",
              "Delete",
              "Edit",
              "SaveAsNew"
            ]
          }
        ]
      }
    }
  },
  "Product": {
    "icon": "gift",
    "items": {
      "Product Info": {
        "views": [
          {
            "type": "List",
            "schema": {"\$ref": "../schema/vendor_ui/product.json#"},
            "database": "misa",
            "component": [
              "Filter",
              "Pagination",
              "Insert",
              "Edit",
              "Delete",
              "DetailModal",
              "SaveAsNew"
            ]
          }
        ]
      },
      "Product Type": {
        "views": [
          {
            "type": "List",
            "schema": {"\$ref": "../schema/vendor_ui/product-type.json#"},
            "database": "misa",
            "component": [
              "Filter",
              "Pagination",
              "Insert",
              "Edit",
              "DetailModal",
              "SaveAsNew",
              "Delete"
            ]
          }
        ]
      }
    }
  },
  "Goods": {
    "icon": "cubes",
    "items": {
      "Goods Info": {
        "views": [
          {
            "type": "List",
            "schema": {"\$ref": "../schema/vendor_ui/goods.json#"},
            "database": "misa",
            "component": [
              "Filter",
              "Pagination",
              "Insert",
              "Edit",
              "Delete",
              "DetailModal",
              "SaveAsNew"
            ]
          }
        ]
      },
      "Goods Type": {
        "views": [
          {
            "type": "List",
            "schema": {"\$ref": "../schema/vendor_ui/goods-type.json#"},
            "database": "misa",
            "component": [
              "Filter",
              "Pagination",
              "Insert",
              "Edit",
              "DetailModal",
              "SaveAsNew",
              "Delete"
            ]
          }
        ]
      },
      "Goods to Product": {
        "views": [
          {
            "type": "QueryList",
            "schema": {"\$ref": "../schema/vendor_ui/goods-product.json#"},
            "database": "misa",
            "component": [
              "Filter",
              "Pagination",
              "Insert",
              "Edit",
              "Delete",
              "DetailModal",
              "SaveAsNew"
            ]
          }
        ]
      },
      "Goods to Product Report": {
        "views": [
          {
            "type": "List",
            "schema": {
              "\$ref": "../schema/vendor_ui/goods-product-report.json#"
            },
            "database": "misa",
            "component": [
              "Filter",
              "Pagination",
              "DetailModal",
              "Export",
              "Import"
            ]
          }
        ]
      }
    }
  },
  "Order": {
    "icon": "shopping-cart",
    "items": {
      "Order Info": {
        "views": [
          {
            "type": "List",
            "schema": {"\$ref": "../schema/vendor_ui/order.json#"},
            "database": "misa",
            "component": [
              "Filter",
              "Pagination",
              "DetailModal",
              "Download",
              "Insert",
              "Edit"
            ]
          }
        ]
      },
      "Order Report": {
        "views": [
          {
            "type": "List",
            "schema": {"\$ref": "../schema/vendor_ui/order-report.json#"},
            "database": "misa",
            "component": [
              "Filter",
              "Pagination",
              "DetailModal",
              "Chart",
              "Export"
            ]
          }
        ]
      }
    }
  },
  "Textbook": {
    "icon": "book",
    "items": {
      "Textbook Info": {
        "views": [
          {
            "type": "List",
            "schema": {"\$ref": "../schema/vendor_ui/textbook.json#"},
            "database": "misa",
            "component": [
              "Filter",
              "Pagination",
              "DetailModal",
              "Insert",
              "Edit",
              "SaveAsNew",
              "Delete"
            ]
          }
        ]
      },
      "Textbook Type": {
        "views": [
          {
            "type": "List",
            "schema": {"\$ref": "../schema/vendor_ui/textbook-type.json#"},
            "database": "misa",
            "component": [
              "Filter",
              "Pagination",
              "DetailModal",
              "Insert",
              "Edit",
              "SaveAsNew",
              "Delete"
            ]
          }
        ]
      },
      "Textbook TOC": {
        "views": [
          {
            "type": "QueryList",
            "schema": {"\$ref": "../schema/vendor_ui/textbook-toc.json#"},
            "database": "misa",
            "component": [
              "Filter",
              "Pagination",
              "DetailModal",
              "Insert",
              "Edit",
              "SaveAsNew",
              "Delete"
            ]
          }
        ]
      },
      "Textbook Resource": {
        "views": [
          {
            "type": "QueryList",
            "schema": {"\$ref": "../schema/vendor_ui/textbook-resource.json#"},
            "database": "misa",
            "component": [
              "Filter",
              "Pagination",
              "DetailModal",
              "Insert",
              "Edit",
              "SaveAsNew",
              "Delete"
            ]
          }
        ]
      }
    }
  },
  "Course": {
    "icon": "graduation-cap",
    "items": {
      "Course Info": {
        "views": [
          {
            "type": "List",
            "schema": {"\$ref": "../schema/vendor_ui/course.json#"},
            "database": "misa",
            "component": [
              "Filter",
              "Pagination",
              "DetailModal",
              "Insert",
              "Edit",
              "SaveAsNew",
              "Delete"
            ]
          }
        ]
      },
      "Course Type": {
        "views": [
          {
            "type": "List",
            "schema": {"\$ref": "../schema/vendor_ui/course-type.json#"},
            "database": "misa",
            "component": [
              "Filter",
              "Pagination",
              "DetailModal",
              "Insert",
              "Edit",
              "SaveAsNew",
              "Delete"
            ]
          }
        ]
      },
      "Create Course from Textbook": {
        "href": "./create-course-from.html?from=textbook",
        "target": "iframe"
      },
      "Copy Whole Course": {
        "href": "./create-course-from.html?from=course",
        "target": "iframe"
      },
      "Course TOC": {
        "views": [
          {
            "type": "QueryList",
            "schema": {"\$ref": "../schema/vendor_ui/course-toc.json#"},
            "database": "misa",
            "component": [
              "Filter",
              "Pagination",
              "DetailModal",
              "Insert",
              "Edit",
              "SaveAsNew",
              "Delete"
            ]
          }
        ]
      },
      "Course Resource": {
        "views": [
          {
            "type": "QueryList",
            "schema": {"\$ref": "../schema/vendor_ui/course-resource.json#"},
            "database": "misa",
            "component": [
              "Filter",
              "Pagination",
              "DetailModal",
              "Insert",
              "Edit",
              "SaveAsNew",
              "Delete"
            ]
          }
        ]
      },
      "Course Member": {
        "views": [
          {
            "type": "QueryList",
            "schema": {"\$ref": "../schema/vendor_ui/course-member.json#"},
            "database": "misa",
            "component": [
              "Filter",
              "Pagination",
              "DetailModal",
              "Insert",
              "Edit",
              "SaveAsNew",
              "Delete"
            ]
          }
        ]
      },
      "Course Member Report": {
        "views": [
          {
            "type": "QueryList",
            "schema": {
              "\$ref": "../schema/vendor_ui/course-member-report.json#"
            },
            "database": "misa",
            "component": [
              "Filter",
              "Pagination",
              "DetailModal",
              "Export",
              "Import"
            ]
          }
        ]
      },
      "Closed Course": {
        "views": [
          {
            "type": "List",
            "schema": {"\$ref": "../schema/vendor_ui/course-closed.json#"},
            "database": "misa",
            "component": ["Filter", "Pagination", "DetailModal", "Edit"]
          }
        ]
      }
    }
  },
  "Bulletin": {
    "icon": "bullhorn",
    "items": {
      "Course Bulletin": {
        "views": [
          {
            "type": "QueryList",
            "schema": {"\$ref": "../schema/vendor_ui/course-bulletin.json#"},
            "database": "misa",
            "component": [
              "Filter",
              "Pagination",
              "DetailModal",
              "Insert",
              "Edit",
              "SaveAsNew",
              "Delete"
            ]
          }
        ]
      }
    }
  },
  "Assignment": {
    "icon": "pencil-square-o",
    "items": {
      "Assignment Info": {
        "views": [
          {
            "type": "List",
            "schema": {"\$ref": "../schema/vendor_ui/assignment.json#"},
            "database": "misa",
            "component": [
              "Filter",
              "Pagination",
              "DetailModal",
              "Insert",
              "Edit",
              "SaveAsNew",
              "Delete"
            ]
          }
        ]
      },
      "Assignment Hand-in": {
        "views": [
          {
            "type": "QueryList",
            "schema": {"\$ref": "../schema/vendor_ui/assignment-hand-in.json#"},
            "database": "misa",
            "component": ["Filter", "Pagination", "DetailModal", "Export"]
          }
        ]
      }
    }
  },
  "Discussion": {
    "icon": "comments",
    "items": {
      "Discussion Topic": {
        "views": [
          {
            "type": "List",
            "schema": {"\$ref": "../schema/vendor_ui/discussion-topic.json#"},
            "database": "misa",
            "component": [
              "Filter",
              "Pagination",
              "DetailModal",
              "Insert",
              "Edit",
              "SaveAsNew",
              "Delete"
            ]
          }
        ]
      },
      "Discussion Post": {
        "views": [
          {
            "type": "QueryList",
            "schema": {"\$ref": "../schema/vendor_ui/discussion-post.json#"},
            "database": "misa",
            "component": [
              "Filter",
              "Pagination",
              "DetailModal",
              "Insert",
              "Edit",
              "SaveAsNew",
              "Delete"
            ]
          }
        ]
      },
      "Discussion Reply": {
        "views": [
          {
            "type": "QueryList",
            "schema": {"\$ref": "../schema/vendor_ui/discussion-reply.json#"},
            "database": "misa",
            "component": [
              "Filter",
              "Pagination",
              "DetailModal",
              "Insert",
              "Edit",
              "SaveAsNew",
              "Delete"
            ]
          }
        ]
      }
    }
  },
  "Promotion": {
    "icon": "tags",
    "items": {
      "Promotion Info": {
        "views": [
          {
            "type": "List",
            "schema": {"\$ref": "../schema/vendor_ui/promotion.json#"},
            "database": "misa",
            "component": [
              "Filter",
              "Pagination",
              "DetailModal",
              "Edit",
              "FormModal",
              "Insert",
              "Delete",
              "SaveAsNew"
            ]
          }
        ]
      },
      "Promotion on Product": {
        "views": [
          {
            "type": "QueryList",
            "schema": {
              "\$ref": "../schema/vendor_ui/promotion-on-product.json#"
            },
            "database": "misa",
            "component": [
              "Filter",
              "Pagination",
              "DetailModal",
              "Insert",
              "Edit",
              "Delete",
              "SaveAsNew"
            ]
          }
        ]
      }
    }
  },
  "Other": {
    "icon": "ellipsis-h",
    "items": {
      "Currency Exchange": {
        "views": [
          {
            "type": "List",
            "schema": {"\$ref": "../schema/vendor_ui/currency-exchange.json#"},
            "database": "misa",
            "component": [
              "Filter",
              "Pagination",
              "DetailModal",
              "Insert",
              "Edit",
              "SaveAsNew"
            ]
          }
        ]
      },
      "Product Price in Currency": {
        "views": [
          {
            "type": "List",
            "schema": {
              "\$ref": "../schema/vendor_ui/product-price-in-currency.json#"
            },
            "database": "misa",
            "component": ["Filter", "Pagination", "DetailModal"]
          }
        ]
      }
    }
  }
};
