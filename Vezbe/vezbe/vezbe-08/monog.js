db.getCollection('movieDetails').find(
    {
        "year": 2015,
        "rated": "R"
    },
)