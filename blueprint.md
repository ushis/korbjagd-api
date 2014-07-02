# Korbjagd API v1

# Group Session

## Session Creation [/v1/sessions]

Resource represents a user session used for authentication and authorization.

### Session Creation [POST]

+ Request (application/json)

  + Body

            {
              "user": {
                "username": "harry",
                "password": "top secret"
              }
            }

+ Response 200 (application/json)

        {
          "user": {
            "id": 4,
            "username": "harry",
            "email": "harry@example.com",
            "notifications_enabled": true,
            "admin": false,
            "baskets_count": 3,
            "created_at": "2014-06-30T17:16:57.041Z",
            "updated_at": "2014-06-30T17:16:57.041Z",
            "auth_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6NCwiZXhwIjoxNDA0MjUxNTcxfQ.l4pJi-gE09SVEFTMrcv3F2ZEJ74u_SUnkVUGyyHEweA",
            "avatar": {
              "id": 2,
              "urls": {
                "thumb": "https://assets.korbjagd.de/uploads/avatars/thumb/8/4/84f07d2b-ea51-462f-ac6c-559cb87d8ae9.png",
                "small": "https://assets.korbjagd.de/uploads/avatars/small/8/4/84f07d2b-ea51-462f-ac6c-559cb87d8ae9.png"
              },
              "created_at": "2014-06-30T17:18:03.989Z",
              "updated_at": "2014-06-30T18:01:21.119Z"
            }
          }
        }

+ Response 401 (application/json)

  + Headers

            WWW-Authenticate: Bearer realm="API"

  + Body

            {
              "error": "Unauthorized",
              "details": {}
            }

# Group Category

## Category Collection [/v1/categories]

Resource represents a collection of basket categories.

### Retrieve Categories [GET]

+ Response 200 (application/json)

        {
          "categories": [
            {
              "id": 1,
              "name": "street"
            },
            {
              "id": 2,
              "name": "court"
            },
            {
              "id": 3,
              "name": "gym"
            }
          ]
        }

# Group Basket

## Basket Collection [/v1/baskets{?bounds}]

Resource represents a collection of baskets located inside the given *bounds*.

+ Parameters

  + bounds (required, array, `['10.1,70.21', '31.33,24.12']`) ...
    coordinates of at least 2 points inside the area to look for baskets

### Retrieve Baskets [GET]

+ Response 200 (application/json)

        {
          "baskets": [
            {
              "id": 10,
              "latitude": 51.33480793148367,
              "longitude": 12.373416423797607
            },
            {
              "id": 9,
              "latitude": 51.33455321533411,
              "longitude": 12.375390529632568
            },
            {
              "id": 11,
              "latitude": 51.33860169398093,
              "longitude": 12.389745712280273
            }
          ],
          "params": {
            "bounds": {
              "south_west": {
                "latitude": 24.12,
                "longitude": 10.1
              },
              "north_east": {
                "latitude": 70.21,
                "longitude": 31.33
              }
            }
          }
        }

## Basket Creation [/v1/baskets]

### Create Basket [POST]

+ Request (application/json)

  + Headers

            Authorization: Bearer JIUzI1NiJ9.eyJpZCI6MSw.rGux2s9X3u

  + Body

            {
              "basket": {
                "name": "Täubchenweg",
                "description": "Toller Platz",
                "latitude": 51.33558882875372,
                "longitude": 12.402094602584839,
                "category_ids": [
                  1,
                  4
                ]
              }
            }

+ Response 201 (application/json)

        {
          "basket": {
            "id": 13,
            "latitude": 51.33558882875372,
            "longitude": 12.402094602584839,
            "name": "Täubchenweg",
            "description": "Schöner Platz",
            "comments_count": 0,
            "created_at": "2014-06-30T20:48:00.205Z",
            "updated_at": "2014-06-30T20:48:00.205Z",
            "user": {
              "id": 4,
              "username": "elly",
              "avatar": {
                "id": 2,
                "urls": {
                  "thumb": "https://assets.korbjagd.de/uploads/avatars/thumb/8/4/84f07d2b-ea51-462f-ac6c-559cb87d8ae9.png",
                  "small": "https://assets.korbjagd.de/uploads/avatars/small/8/4/84f07d2b-ea51-462f-ac6c-559cb87d8ae9.png"
                },
                "created_at": "2014-06-30T17:18:03.989Z",
                "updated_at": "2014-06-30T18:01:21.119Z"
              }
            },
            "photo": null,
            "categories": [
              {
                "id": 1,
                "name": "street"
              },
              {
                "id": 4,
                "name": "park"
              }
            ]
          }
        }

+ Response 401 (application/json)

  + Headers

            WWW-Authenticate: Bearer realm="API"

  + Body

            {
              "error": "Unauthorized",
              "details": {}
            }

+ Response 422 (application/json)

        {
          "error": "Unprocessable Entity",
          "details": {
            "name": [
              "can't be blank"
            ],
            "latitude": [
              "can't be blank"
            ],
            "longitude": [
              "can't be blank"
            ]
          }
        }

## Basket [/v1/baskets/{id}]

Resource represents one particular basket identified by its *id*.

+ Parameters

  + id (required, integer, `12`) ... `id` identifying the basket

### Retrieve Basket [GET]

+ Response 200 (application/json)

        {
          "basket": {
            "id": 10,
            "latitude": 51.33480793148367,
            "longitude": 12.373416423797607,
            "name": "Friedenspark",
            "description": "Der Korb steht hinten in der Ecke. Findet man schon...",
            "comments_count": 3,
            "created_at": "2014-06-30T17:35:09.498Z",
            "updated_at": "2014-06-30T18:49:45.324Z",
            "user": {
              "id": 4,
              "username": "bill",
              "avatar": {
                "id": 2,
                "urls": {
                  "thumb": "https://assets.korbjagd.de/uploads/avatars/thumb/8/4/84fb-ea51-462f-ac6c-5597d8ae9.png",
                  "small": "https://assets.korbjagd.de/uploads/avatars/small/8/4/84fb-ea51-462f-ac6c-559cb8ae9.png"
                },
                "created_at": "2014-06-30T17:18:03.989Z",
                "updated_at": "2014-06-30T18:01:21.119Z"
              }
            },
            "photo": {
              "id": 7,
              "urls": {
                "thumb": "https://assets.korbjagd.de/uploads/photos/thumb/0/e/0e69-42b3-4247-a49d-6acc7a7fd.png",
                "small": "https://assets.korbjagd.de/uploads/photos/small/0/e/0e69-42b3-4247-a49d-6acc7a7fd.png",
                "medium": "https://assets.korbjagd.de/uploads/photos/medium/0/e/0e69-42b3-4247-a49d-6acc7a7fd.png"
              },
              "created_at": "2014-06-30T17:35:17.144Z",
              "updated_at": "2014-06-30T17:35:17.144Z"
            },
            "categories": [
              {
                "id": 1,
                "name": "street"
              },
              {
                "id": 2,
                "name": "court"
              }
            ]
          }
        }

+ Response 404 (application/json)

        {
          "error": "Not Found",
          "details": {}
        }

### Update Basket [PATCH]

+ Request (application/json)

  + Headers

            Authorization: Bearer JIUzI1NiJ9.eyJpZCI6MSw.rGux2s9X3u

  + Body

            {
              "basket": {
                "description": "Toller Platz, aber viel los.",
                "category_ids": [
                  1
                ]
              }
            }

+ Response 200 (application/json)

        {
          "basket": {
            "id": 10,
            "latitude": 51.33480793148367,
            "longitude": 12.373416423797607,
            "name": "Freibierwiesen",
            "description": "Toller Platz, aber viel los.",
            "comments_count": 0,
            "created_at": "2014-06-30T17:35:09.498Z",
            "updated_at": "2014-06-30T21:18:31.727Z",
            "user": {
              "id": 4,
              "username": "michael",
              "avatar": {
                "id": 2,
                "urls": {
                  "thumb": "https://assets.korbjagd.de/uploads/avatars/thumb/8/4/84f07d2b-ea51-462f-ac6c-559cb87d8ae9.png",
                  "small": "https://assets.korbjagd.de/uploads/avatars/small/8/4/84f07d2b-ea51-462f-ac6c-559cb87d8ae9.png"
                },
                "created_at": "2014-06-30T17:18:03.989Z",
                "updated_at": "2014-06-30T18:01:21.119Z"
              }
            },
            "photo": {
              "id": 7,
              "urls": {
                "thumb": "https://assets.korbjagd.de/uploads/photos/thumb/0/e/0e69c21f-42b3-4247-a49d-b246acc7a7fd.png",
                "small": "https://assets.korbjagd.de/uploads/photos/small/0/e/0e69c21f-42b3-4247-a49d-b246acc7a7fd.png",
                "medium": "https://assets.korbjagd.de/uploads/photos/medium/0/e/0e69c21f-42b3-4247-a49d-b246acc7a7fd.png"
              },
              "created_at": "2014-06-30T17:35:17.144Z",
              "updated_at": "2014-06-30T17:35:17.144Z"
            },
            "categories": [
              {
                "id": 1,
                "name": "street"
              }
            ]
          }
        }

+ Response 401 (application/json)

  + Headers

            WWW-Authenticate: Bearer realm="API"

  + Body

            {
              "error": "Unauthorized",
              "details": {}
            }

+ Response 404 (application/json)

        {
          "error": "Not Found",
          "details": {}
        }

+ Response 422 (application/json)

        {
          "error": "Unprocessable Entity",
          "details": {
            "name": [
              "can't be blank"
            ],
          }
        }

### Delete Basket [DELETE]

+ Request

  + Headers

            Authorization: Bearer JIUzI1NiJ9.eyJpZCI6MSw.rGux2s9X3u

+ Response 204

+ Response 401 (application/json)

  + Headers

            WWW-Authenticate: Bearer realm="API"

  + Body

            {
              "error": "Unauthorized",
              "details": {}
            }

+ Response 404 (application/json)

        {
          "error": "Not Found",
          "details": {}
        }

# Group Comment

## Comment Collection [/v1/baskets/{basket_id}/comments]

Resource represents all comments of a basket.

+ Parameters

  + basket_id (required, integer, `12`) ... `id` identifying the basket

### Retrieve Comments [GET]

+ Response 200 (application/json)

        {
          "comments": [
            {
              "id": 6,
              "comment": "Korb ist leider kaputt.",
              "created_at": "2014-06-30T19:38:10.743Z",
              "updated_at": "2014-06-30T19:38:10.743Z",
              "user": {
                "id": 4,
                "username": "peter",
                "avatar": {
                  "id": 3,
                  "urls": {
                    "thumb": "https://assets.korbjagd.de/uploads/avatars/thumb/8/4/84f07d2b-ea51-462f-ac6c-559cb87d8ae9.png",
                    "small": "https://assets.korbjagd.de/uploads/avatars/small/8/4/84f07d2b-ea51-462f-ac6c-559cb87d8ae9.png"
                  },
                  "created_at": "2014-06-30T17:18:03.989Z",
                  "updated_at": "2014-06-30T18:01:21.119Z"
                }
              }
            },
            {
              "id": 7,
              "comment": "Wurde repariert.",
              "created_at": "2014-06-30T19:38:16.588Z",
              "updated_at": "2014-06-30T19:38:16.588Z",
              "user": {
                "id": 7,
                "username": "eva",
                "avatar": {
                  "id": 8,
                  "urls": {
                    "thumb": "https://assets.korbjagd.de/uploads/avatars/thumb/8/4/84f07d2b-ea51-462f-ac6c-559cb87d8ae9.png",
                    "small": "https://assets.korbjagd.de/uploads/avatars/small/8/4/84f07d2b-ea51-462f-ac6c-559cb87d8ae9.png"
                  },
                  "created_at": "2014-06-30T17:18:03.989Z",
                  "updated_at": "2014-06-30T18:01:21.119Z"
                }
              }
            },
            {
              "id": 8,
              "comment": "Stimmt nicht. War gestern immernoch kaputt.",
              "created_at": "2014-06-30T19:43:10.447Z",
              "updated_at": "2014-06-30T19:43:10.447Z",
              "user": {
                "id": 4,
                "username": "peter",
                "avatar": {
                  "id": 3,
                  "urls": {
                    "thumb": "https://assets.korbjagd.de/uploads/avatars/thumb/8/4/84f07d2b-ea51-462f-ac6c-559cb87d8ae9.png",
                    "small": "https://assets.korbjagd.de/uploads/avatars/small/8/4/84f07d2b-ea51-462f-ac6c-559cb87d8ae9.png"
                  },
                  "created_at": "2014-06-30T17:18:03.989Z",
                  "updated_at": "2014-06-30T18:01:21.119Z"
                }
              }
            }
          ]
        }

+ Response 404 (application/json)

        {
          "error": "Not Found",
          "details": {}
        }

### Create Comment [POST]

+ Request (application/json)

  + Headers

            Authorization: Bearer JIUzI1NiJ9.eyJpZCI6MSw.rGux2s9X3u

  + Body

            {
              "comment": {
                "comment": "Das ist ein super Korb!"
              }
            }

+ Response 201 (application/json)

        {
          "comment": {
            "id": 10,
            "comment": "Das ist ein super Korb!",
            "created_at": "2014-06-30T22:17:56.198Z",
            "updated_at": "2014-06-30T22:17:56.198Z",
            "user": {
              "id": 4,
              "username": "harry",
              "avatar": {
                "id": 3,
                "urls": {
                  "thumb": "https://assets.korbjagd.de/uploads/avatars/thumb/8/4/84f07d2b-ea51-462f-ac6c-559cb87d8ae9.png",
                  "small": "https://assets.korbjagd.de/uploads/avatars/small/8/4/84f07d2b-ea51-462f-ac6c-559cb87d8ae9.png"
                },
                "created_at": "2014-06-30T17:18:03.989Z",
                "updated_at": "2014-06-30T18:01:21.119Z"
              }
            }
          }
        }

+ Response 401 (application/json)

  + Headers

            WWW-Authenticate: Bearer realm="API"

  + Body

            {
              "error": "Unauthorized",
              "details": {}
            }

+ Response 404 (application/json)

        {
          "error": "Not Found",
          "details": {}
        }

+ Response 422 (application/json)

        {
          "error": "Unprocessable Entity",
          "details": {
            "comment": [
              "can't be blank"
            ]
          }
        }

## Comment [/v1/baskets/{basket_id}/comments/{id}]

Resource represents one particular comment identified by its *id* and its baskets id.

+ Parameters

  + id (required, integer, `756`) ... `id` identifying the comment

  + basket_id (required, integer, `51`) ... `id` identifying the basket

### Retrieve Comment [GET]

+ Response 200 (application/json)

        {
          "comment": {
            "id": 10,
            "comment": "Das ist ein super Korb!",
            "created_at": "2014-06-30T22:17:56.198Z",
            "updated_at": "2014-06-30T22:17:56.198Z",
            "user": {
              "id": 4,
              "username": "harry",
              "avatar": {
                "id": 3,
                "urls": {
                  "thumb": "https://assets.korbjagd.de/uploads/avatars/thumb/8/4/84f07d2b-ea51-462f-ac6c-559cb87d8ae9.png",
                  "small": "https://assets.korbjagd.de/uploads/avatars/small/8/4/84f07d2b-ea51-462f-ac6c-559cb87d8ae9.png"
                },
                "created_at": "2014-06-30T17:18:03.989Z",
                "updated_at": "2014-06-30T18:01:21.119Z"
              }
            }
          }
        }

+ Response 404 (application/json)

        {
          "error": "Not Found",
          "details": {}
        }

### Update Comment [PATCH]

+ Request (application/json)

  + Headers

            Authorization: Bearer JIUzI1NiJ9.eyJpZCI6MSw.rGux2s9X3u

  + Body

            {
              "comment": {
                "comment": "Ich glaube, dass dieser Korb schon lang nicht mehr existiert."
              }
            }

+ Response 200 (application/json)

        {
          "comment": {
            "id": 10,
            "comment": "Ich glaube, dass dieser Korb schon lang nicht mehr existiert.",
            "created_at": "2014-06-30T22:17:56.198Z",
            "updated_at": "2014-06-30T23:23:53.123Z",
            "user": {
              "id": 4,
              "username": "harry",
              "avatar": {
                "id": 3,
                "urls": {
                  "thumb": "https://assets.korbjagd.de/uploads/avatars/thumb/8/4/84f07d2b-ea51-462f-ac6c-559cb87d8ae9.png",
                  "small": "https://assets.korbjagd.de/uploads/avatars/small/8/4/84f07d2b-ea51-462f-ac6c-559cb87d8ae9.png"
                },
                "created_at": "2014-06-30T17:18:03.989Z",
                "updated_at": "2014-06-30T18:01:21.119Z"
              }
            }
          }
        }

+ Response 401 (application/json)

  + Headers

            WWW-Authenticate: Bearer realm="API"

  + Body

            {
              "error": "Unauthorized",
              "details": {}
            }

+ Response 403 (application/json)

        {
          "error": "Forbidden",
          "details": {}
        }

+ Response 404 (application/json)

        {
          "error": "Not Found",
          "details": {}
        }

+ Response 422 (application/json)

        {
          "error": "Unprocessable Entity",
          "details": {
            "comment": [
              "can't be blank"
            ]
          }
        }

### Delete Comment [DELETE]

+ Request

  + Headers

            Authorization: Bearer JIUzI1NiJ9.eyJpZCI6MSw.rGux2s9X3u

+ Response 204

+ Response 401 (application/json)

  + Headers

            WWW-Authenticate: Bearer realm="API"

  + Body

            {
              "error": "Unauthorized",
              "details": {}
            }

+ Response 403 (application/json)

        {
          "error": "Forbidden",
          "details": {}
        }

+ Response 404 (application/json)

        {
          "error": "Not Found",
          "details": {}
        }

# Group Photo

## Photo [/v1/baskets/{basket_id}/photo]

Resource represents one particular basket photo.

+ Parameters

  + basket_id (required, integer, `51`) ... `id` identifying the basket

### Create Photo [POST]

+ Request (multipart/form-data, boundary=AaB03x)

  + Headers

            Content-Length: 87632642
            Authorization: Bearer JIUzI1NiJ9.eyJpZCI6MSw.rGux2s9X3u

  + Body

            --AaB03x
            content-disposition: form-data; name="photo[image]"; filename="basket.png"
            Content-Type: image/png
            Content-Transfer-Encoding: binary

            BINARYDATA
            --AaB03x--

+ Response 201 (application/json)

        {
          "photo": {
            "id": 6,
            "urls": {
              "thumb": "https://assets.korbjagd.de/uploads/photos/thumb/b/7/b752c678-d28d-4368-8c64-5b8e9a24a83e.png",
              "small": "https://assets.korbjagd.de/uploads/photos/small/b/7/b752c678-d28d-4368-8c64-5b8e9a24a83e.png",
              "medium": "https://assets.korbjagd.de/uploads/photos/medium/b/7/b752c678-d28d-4368-8c64-5b8e9a24a83e.png"
            },
            "created_at": "2014-06-30T16:46:34.998Z",
            "updated_at": "2014-06-30T16:46:34.998Z"
          }
        }

+ Response 401 (application/json)

  + Headers

            WWW-Authenticate: Bearer realm="API"

  + Body

            {
              "error": "Unauthorized",
              "details": {}
            }

+ Response 404 (application/json)

        {
          "error": "Not Found",
          "details": {}
        }

+ Response 422 (application/json)

        {
          "error": "Unprocessable Entity",
          "details": {
            "filename": [
              "can't be blank"
            ],
            "image":[
              "can't be blank",
              "You are not allowed to upload \"pdf\" files, allowed types: jpg, jpeg, gif, png"
            ]
          }
        }

### Retrieve Photo [GET]

+ Response 200 (application/json)

        {
          "photo": {
            "id": 6,
            "urls": {
              "thumb": "https://assets.korbjagd.de/uploads/photos/thumb/b/7/b752c678-d28d-4368-8c64-5b8e9a24a83e.png",
              "small": "https://assets.korbjagd.de/uploads/photos/small/b/7/b752c678-d28d-4368-8c64-5b8e9a24a83e.png",
              "medium": "https://assets.korbjagd.de/uploads/photos/medium/b/7/b752c678-d28d-4368-8c64-5b8e9a24a83e.png"
            },
            "created_at": "2014-06-30T16:46:34.998Z",
            "updated_at": "2014-06-30T16:46:34.998Z"
          }
        }

+ Response 404 (application/json)

        {
          "error": "Not Found",
          "details": {}
        }

### Update Photo [PATCH]

+ Request (multipart/form-data, boundary=AaB03x)

  + Headers

            Content-Length: 87632642
            Authorization: Bearer JIUzI1NiJ9.eyJpZCI6MSw.rGux2s9X3u

  + Body

            --AaB03x
            content-disposition: form-data; name="photo[image]"; filename="basket.png"
            Content-Type: image/png
            Content-Transfer-Encoding: binary

            BINARYDATA
            --AaB03x--

+ Response 200 (application/json)

        {
          "photo": {
            "id": 6,
            "urls": {
              "thumb": "https://assets.korbjagd.de/uploads/photos/thumb/b/7/b752c678-d28d-4368-8c64-5b8e9a24a83e.png",
              "small": "https://assets.korbjagd.de/uploads/photos/small/b/7/b752c678-d28d-4368-8c64-5b8e9a24a83e.png",
              "medium": "https://assets.korbjagd.de/uploads/photos/medium/b/7/b752c678-d28d-4368-8c64-5b8e9a24a83e.png"
            },
            "created_at": "2014-06-30T16:46:34.998Z",
            "updated_at": "2014-06-30T16:46:34.998Z"
          }
        }

+ Response 401 (application/json)

  + Headers

            WWW-Authenticate: Bearer realm="API"

  + Body

            {
              "error": "Unauthorized",
              "details": {}
            }

+ Response 404 (application/json)

        {
          "error": "Not Found",
          "details": {}
        }

+ Response 422 (application/json)

        {
          "error": "Unprocessable Entity",
          "details": {
            "filename": [
              "can't be blank"
            ],
            "image":[
              "can't be blank",
              "You are not allowed to upload \"pdf\" files, allowed types: jpg, jpeg, gif, png"
            ]
          }
        }

# Delete Photo [DELETE]

+ Request

  + Headers

            Authorization: Bearer JIUzI1NiJ9.eyJpZCI6MSw.rGux2s9X3u

+ Response 201

+ Response 401 (application/json)

  + Headers

            WWW-Authenticate: Bearer realm="API"

  + Body

            {
              "error": "Unauthorized",
              "details": {}
            }

+ Response 404 (application/json)

        {
          "error": "Not Found",
          "details": {}
        }

# Group User

## User Collection [/v1/users]

Resource represents a collection of users.

### Retrieve Users [GET]

+ Request

  + Headers

            Authorization: Bearer JIUzI1NiJ9.eyJpZCI6MSw.rGux2s9X3u

+ Response 200 (application/json)

        {
          "users": [
            {
              "id": 4,
              "username": "harry",
              "avatar": {
                "id": 3,
                "urls": {
                  "thumb": "https://assets.korbjagd.de/uploads/avatars/thumb/8/4/84f07d2b-ea51-462f-ac6c-559cb87d8ae9.png",
                  "small": "https://assets.korbjagd.de/uploads/avatars/small/8/4/84f07d2b-ea51-462f-ac6c-559cb87d8ae9.png"
                },
                "created_at": "2014-06-30T17:18:03.989Z",
                "updated_at": "2014-06-30T18:01:21.119Z"
              }
            },
            {
              "id": 45,
              "username": "elly",
              "avatar": {
                "id": 5,
                "urls": {
                  "thumb": "https://assets.korbjagd.de/uploads/avatars/thumb/8/4/84f07d2b-ea51-462f-ac6c-559cb87d8ae9.png",
                  "small": "https://assets.korbjagd.de/uploads/avatars/small/8/4/84f07d2b-ea51-462f-ac6c-559cb87d8ae9.png"
                },
                "created_at": "2014-06-30T17:18:03.989Z",
                "updated_at": "2014-06-30T18:01:21.119Z"
              }
            }
          ]
        }

+ Response 401 (application/json)

  + Headers

            WWW-Authenticate: Bearer realm="API"

  + Body

            {
              "error": "Unauthorized",
              "details": {}
            }

### Create User [POST]

+ Request (application/json)

  + Body

            {
              "user": {
                "username": "scotty",
                "email": "scotty@example.com",
                "password": "top secret",
                "password_confirmation": "top secret"
              }
            }

+ Response 201 (application/json)

        {
          "user": {
            "id": 5,
            "username": "scotty",
            "email": "scotty@example.com",
            "notifications_enabled": true,
            "admin": false,
            "baskets_count": 0,
            "created_at": "2014-06-30T23:26:05.993Z",
            "updated_at": "2014-06-30T23:26:05.993Z",
            "avatar": null
          }
        }

+ Response 422 (application/json)

        {
          "error": "Unprocessable Entity",
          "details": {
            "username": [
              "has already been taken"
            ]
          }
        }

## User [/v1/users/{id}]

Resource represents one particular user identified by its *id*.

+ Parameters

  + id (required, integer, `627`) ... `id` identifying the user

### Retrieve User [GET]

+ Request

  + Headers

            Authorization: Bearer JIUzI1NiJ9.eyJpZCI6MSw.rGux2s9X3u

+ Response 200 (application/json)

        {
          "user": {
            "id": 4,
            "username": "peter",
            "email": "peter@example.com",
            "notifications_enabled": true,
            "admin": false,
            "baskets_count": 3,
            "created_at": "2014-06-30T17:16:57.041Z",
            "updated_at": "2014-06-30T17:16:57.041Z",
            "avatar": {
              "id": 2,
              "urls": {
                "thumb": "https://assets.korbjagd.de/uploads/avatars/thumb/8/4/84f07d2b-ea51-462f-ac6c-559cb87d8ae9.png",
                "small": "https://assets.korbjagd.de/uploads/avatars/small/8/4/84f07d2b-ea51-462f-ac6c-559cb87d8ae9.png"
              },
              "created_at": "2014-06-30T17:18:03.989Z",
              "updated_at": "2014-06-30T18:01:21.119Z"
            }
          }
        }

+ Response 401 (application/json)

  + Headers

            WWW-Authenticate: Bearer realm="API"

  + Body

            {
              "error": "Unauthorized",
              "details": {}
            }

+ Response 403 (application/json)

        {
          "error": "Forbidden",
          "details": {}
        }

+ Response 404 (application/json)

        {
          "error": "Not Found",
          "details": {}
        }

### Update User [PATCH]

+ Request (application/json)

  + Headers

            Authorization: Bearer JIUzI1NiJ9.eyJpZCI6MSw.rGux2s9X3u

  + Body

            {
              "user": {
                "email": "peter@aol.com",
                "notifications_enabled": false,
                "password": "super top secret",
                "password_confirmation": "super top secret"
              }
            }

+ Response 200 (application/json)


        {
          "user": {
            "id": 4,
            "username": "peter",
            "email": "peter@aol.com",
            "notifications_enabled": false,
            "admin": false,
            "baskets_count": 3,
            "created_at": "2014-06-30T17:16:57.041Z",
            "updated_at": "2014-06-30T17:16:57.041Z",
            "avatar": {
              "id": 2,
              "urls": {
                "thumb": "https://assets.korbjagd.de/uploads/avatars/thumb/8/4/84f07d2b-ea51-462f-ac6c-559cb87d8ae9.png",
                "small": "https://assets.korbjagd.de/uploads/avatars/small/8/4/84f07d2b-ea51-462f-ac6c-559cb87d8ae9.png"
              },
              "created_at": "2014-06-30T17:18:03.989Z",
              "updated_at": "2014-06-30T18:01:21.119Z"
            }
          }
        }

+ Response 401 (application/json)

  + Headers

            WWW-Authenticate: Bearer realm="API"

  + Body

            {
              "error": "Unauthorized",
              "details": {}
            }

+ Response 403 (application/json)

        {
          "error": "Forbidden",
          "details": {}
        }

+ Response 404 (application/json)

        {
          "error": "Not Found",
          "details": {}
        }

+ Response 422 (application/json)

        {
          "error": "Unprocessable Entity",
          "details": {
            "email": [
              "can't be blank",
              "is invalid"
            ]
          }
        }

### Delete User [DELETE]

+ Request

  + Headers

            Authorization: Bearer JIUzI1NiJ9.eyJpZCI6MSw.rGux2s9X3u

+ Response 201

+ Response 401 (application/json)

  + Headers

            WWW-Authenticate: Bearer realm="API"

  + Body

            {
              "error": "Unauthorized",
              "details": {}
            }

+ Response 403 (application/json)

        {
          "error": "Forbidden",
          "details": {}
        }

+ Response 404 (application/json)

        {
          "error": "Not Found",
          "details": {}
        }

# Group Avatar

## Avatar [/v1/users/{user_id}/avatar]

Resource represents one particular user avatar.

+ Parameters

  + user_id (required, integer, `51`) ... `id` identifying the user

### Create Avatar [POST]

+ Request (multipart/form-data, boundary=AaB03x)

  + Headers

            Content-Length: 87632642
            Authorization: Bearer JIUzI1NiJ9.eyJpZCI6MSw.rGux2s9X3u

  + Body

            --AaB03x
            content-disposition: form-data; name="avatar[image]"; filename="user.png"
            Content-Type: image/png
            Content-Transfer-Encoding: binary

            BINARYDATA
            --AaB03x--

+ Response 201 (application/json)

        {
          "avatar": {
            "id": 23,
            "urls": {
              "thumb": "https://assets.korbjagd.de/uploads/avatars/thumb/b/7/b752c678-d28d-4368-8c64-5b8e9a24a83e.png",
              "small": "https://assets.korbjagd.de/uploads/avatars/small/b/7/b752c678-d28d-4368-8c64-5b8e9a24a83e.png",
            },
            "created_at": "2014-06-30T16:46:34.998Z",
            "updated_at": "2014-06-30T16:46:34.998Z"
          }
        }

+ Response 401 (application/json)

  + Headers

            WWW-Authenticate: Bearer realm="API"

  + Body

            {
              "error": "Unauthorized",
              "details": {}
            }

+ Response 404 (application/json)

        {
          "error": "Not Found",
          "details": {}
        }

+ Response 422 (application/json)

        {
          "error": "Unprocessable Entity",
          "details": {
            "filename": [
              "can't be blank"
            ],
            "image":[
              "can't be blank",
              "You are not allowed to upload \"pdf\" files, allowed types: jpg, jpeg, gif, png"
            ]
          }
        }

### Retrieve Avatar [GET]

+ Response 200 (application/json)

        {
          "avatar": {
            "id": 23,
            "urls": {
              "thumb": "https://assets.korbjagd.de/uploads/avatars/thumb/b/7/b752c678-d28d-4368-8c64-5b8e9a24a83e.png",
              "small": "https://assets.korbjagd.de/uploads/avatars/small/b/7/b752c678-d28d-4368-8c64-5b8e9a24a83e.png",
            },
            "created_at": "2014-06-30T16:46:34.998Z",
            "updated_at": "2014-06-30T16:46:34.998Z"
          }
        }

+ Response 404 (application/json)

        {
          "error": "Not Found",
          "details": {}
        }

### Update Avatar [PATCH]

+ Request (multipart/form-data, boundary=AaB03x)

  + Headers

            Content-Length: 87632642
            Authorization: Bearer JIUzI1NiJ9.eyJpZCI6MSw.rGux2s9X3u

  + Body

            --AaB03x
            content-disposition: form-data; name="avatar[image]"; filename="basket.png"
            Content-Type: image/png
            Content-Transfer-Encoding: binary

            BINARYDATA
            --AaB03x--

+ Response 200 (application/json)

        {
          "avatar": {
            "id": 23,
            "urls": {
              "thumb": "https://assets.korbjagd.de/uploads/avatars/thumb/b/7/b752c678-d28d-4368-8c64-5b8e9a24a83e.png",
              "small": "https://assets.korbjagd.de/uploads/avatars/small/b/7/b752c678-d28d-4368-8c64-5b8e9a24a83e.png",
            },
            "created_at": "2014-06-30T16:46:34.998Z",
            "updated_at": "2014-06-30T16:46:34.998Z"
          }
        }

+ Response 401 (application/json)

  + Headers

            WWW-Authenticate: Bearer realm="API"

  + Body

            {
              "error": "Unauthorized",
              "details": {}
            }

+ Response 404 (application/json)

        {
          "error": "Not Found",
          "details": {}
        }

+ Response 422 (application/json)

        {
          "error": "Unprocessable Entity",
          "details": {
            "filename": [
              "can't be blank"
            ],
            "image":[
              "can't be blank",
              "You are not allowed to upload \"pdf\" files, allowed types: jpg, jpeg, gif, png"
            ]
          }
        }

# Delete Avatar [DELETE]

+ Request

  + Headers

            Authorization: Bearer JIUzI1NiJ9.eyJpZCI6MSw.rGux2s9X3u

+ Response 201

+ Response 401 (application/json)

  + Headers

            WWW-Authenticate: Bearer realm="API"

  + Body

            {
              "error": "Unauthorized",
              "details": {}
            }

+ Response 404 (application/json)

        {
          "error": "Not Found",
          "details": {}
        }

# Group Profile

## Profile [/v1/profile]

Resource represents the user identified by *Authorization* header.

### Retrieve Profile [GET]

+ Request

  + Headers

            Authorization: Bearer JIUzI1NiJ9.eyJpZCI6MSw.rGux2s9X3u

+ Response 200 (application/json)

        {
          "user": {
            "id": 4,
            "username": "peter",
            "email": "peter@aol.com",
            "notifications_enabled": true,
            "admin": false,
            "baskets_count": 3,
            "created_at": "2014-06-30T17:16:57.041Z",
            "updated_at": "2014-06-30T23:38:52.985Z",
            "avatar": {
              "id": 2,
              "urls": {
                "thumb": "https://assets.korbjagd.de/uploads/avatars/thumb/8/4/84f07d2b-ea51-462f-ac6c-559cb87d8ae9.png",
                "small": "https://assets.korbjagd.de/uploads/avatars/small/8/4/84f07d2b-ea51-462f-ac6c-559cb87d8ae9.png"
              },
              "created_at": "2014-06-30T17:18:03.989Z",
              "updated_at": "2014-06-30T18:01:21.119Z"
            }
          }
        }

+ Response 401 (application/json)

  + Headers

            WWW-Authenticate: Bearer realm="API"

  + Body

            {
              "error": "Unauthorized",
              "details": {}
            }

### Update Profile [PATCH]

+ Request (application/json)

  + Headers

            Authorization: Bearer JIUzI1NiJ9.eyJpZCI6MSw.rGux2s9X3u

  + Body

            {
              "user": {
                "email": "peter@example.com",
                "notifications_enabled": false
              }
            }

+ Response 200 (application/json)

        {
          "user": {
            "id": 4,
            "username": "peter",
            "email": "peter@example.com",
            "notifications_enabled": false,
            "admin": false,
            "baskets_count": 3,
            "created_at": "2014-06-30T17:16:57.041Z",
            "updated_at": "2014-06-30T23:38:52.985Z",
            "avatar": {
              "id": 2,
              "urls": {
                "thumb": "https://assets.korbjagd.de/uploads/avatars/thumb/8/4/84f07d2b-ea51-462f-ac6c-559cb87d8ae9.png",
                "small": "https://assets.korbjagd.de/uploads/avatars/small/8/4/84f07d2b-ea51-462f-ac6c-559cb87d8ae9.png"
              },
              "created_at": "2014-06-30T17:18:03.989Z",
              "updated_at": "2014-06-30T18:01:21.119Z"
            }
          }
        }

+ Response 401 (application/json)

  + Headers

            WWW-Authenticate: Bearer realm="API"

  + Body

            {
              "error": "Unauthorized",
              "details": {}
            }

+ Response 422 (application/json)

        {
          "error": "Unprocessable Entity",
          "details": {
            "email": [
              "can't be blank",
              "is invalid"
            ]
          }
        }

### Delete Profile [DELETE]

+ Request

  + Headers

            Authorization: Bearer JIUzI1NiJ9.eyJpZCI6MSw.rGux2s9X3u

+ Response 401 (application/json)

  + Headers

            WWW-Authenticate: Bearer realm="API"

  + Body

            {
              "error": "Unauthorized",
              "details": {}
            }
