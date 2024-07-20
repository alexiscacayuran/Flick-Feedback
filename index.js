import express from "express";
import bodyParser from "body-parser";
import pg from "pg";
import axios from "axios";
import session from "express-session";
import truncate from "truncate-html";
import { QuillDeltaToHtmlConverter } from "quill-delta-to-html";
import env from "dotenv";

const app = express();
const port = 3000;
const API_URL = `http://www.omdbapi.com/`;
const apiKey = process.env.API_KEY;
env.config();

const db = new pg.Client({
  user: process.env.PG_USER,
  host: process.env.PG_HOST,
  database: process.env.PG_DATABASE,
  password: process.env.PG_PASSWORD,
  port: process.env.PG_PORT,
});

db.connect();

const months = [
  "Jan",
  "Feb",
  "Mar",
  "Apr",
  "May",
  "Jun",
  "Jul",
  "Aug",
  "Sep",
  "Oct",
  "Nov",
  "Dec",
];

app.use(bodyParser.urlencoded({ extended: true }));
app.use(express.static("public"));
app.use(
  session({
    secret: "your_secret_key",
    resave: false,
    saveUninitialized: true,
  })
);

app.use((req, res, next) => {
  if (
    req.params.id == "favicon.ico" ||
    req.params.id == "android-chrome-192x192.png"
  )
    req.params.id = null;
  next();
});

app.get("/", async (req, res) => {
  const result = await db.query(
    "SELECT * FROM movies INNER JOIN notes ON movies.id = notes.movie_id ORDER BY movie_id ASC"
  );
  const data = result.rows;
  data.forEach((movie) => {
    movie.genre = movie.genre.split(", ");

    let d = new Date(movie.date_watched);
    let month = months[d.getMonth()];
    let year = d.getFullYear();
    movie.date_watched = month + " " + year;

    let cfg = {};
    let converter = new QuillDeltaToHtmlConverter(JSON.parse(movie.notes), cfg);
    movie.notes = converter.convert();
    movie.notes = truncate(movie.notes, 60, {
      byWords: true,
      excludes: ["br"],
    });
  });

  console.log(data[0]);
  res.render("index.ejs", { movies: data });
});

app.get("/add", (req, res) => {
  if (req.session.data) {
    //console.log(req.session.data);
    res.render("add.ejs", { movie: req.session.data });
  } else {
    res.render("add.ejs");
  }
});

app.post("/search", async (req, res) => {
  const movieToAdd = req.body.movieToAdd.trim().replace(/\W/g, "+");

  //console.log(movieToAdd);

  const response = await axios.get(`${API_URL}`, {
    params: {
      apiKey: apiKey,
      t: movieToAdd,
    },
  });

  if (response.data.Response == "True") {
    //console.log(response.data);
    response.data.Genre = response.data.Genre.split(", ");
    req.session.data = response.data;
    res.redirect("/add");
  } else {
    console.log(response.data.Error);
    res.sendStatus(404);
  }
});

app.post("/add", async (req, res) => {
  // console.log(req.body.title);
  // console.log(req.body.flickRating);
  // console.log(req.body.dateWatched);
  // console.log(req.body.recommended);
  // console.log(req.body.notes);
  //console.log(req.body.title);
  const movieToAdd = req.body.title.trim().replace(/\W/g, "+");

  const response = await axios.get(`${API_URL}`, {
    params: {
      apiKey: apiKey,
      t: movieToAdd,
    },
  });

  let title = response.data.Title;
  let year = response.data.Year;
  let rated = response.data.Rated;
  let release_date = response.data.Released;
  let runtime = response.data.Runtime;
  let genre = response.data.Genre;
  let actors = response.data.Actors;
  let plot = response.data.Plot;
  let poster = response.data.Poster;
  let imdb_rating = response.data.imdbRating;

  const result = await db.query(
    "INSERT INTO movies (title, year, release_date, genre, actors, plot, poster, imdb_rating, rated, runtime) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10) RETURNING id",
    [
      title,
      year,
      release_date,
      genre,
      actors,
      plot,
      poster,
      imdb_rating,
      rated,
      runtime,
    ]
  );

  let flick_rating = req.body.flickRating;
  let date_watched = req.body.dateWatched;
  date_watched = date_watched.slice(0, 2) + "-1" + date_watched.slice(2);

  let recommended = req.body.recommended;
  let notes = req.body.notes;

  let movie_id = result.rows[0].id;

  await db.query(
    "INSERT INTO notes (flick_rating, date_watched, recommended, notes, movie_id) VALUES ($1, $2, $3, $4, $5)",
    [flick_rating, date_watched, recommended, notes, movie_id]
  );

  res.redirect("/");
});

app.get("/:id/edit", async (req, res) => {
  const movieId = req.params.id;
  const result = await db.query(
    "SELECT * FROM movies INNER JOIN notes ON movies.id = notes.movie_id WHERE movies.id = $1",
    [movieId]
  );

  const data = result.rows[0];
  data.genre = data.genre.split(", ");

  let d = new Date(data.date_watched);
  let month = d.getMonth() + 1;
  let year = d.getFullYear();
  data.date_watched = "0" + month + "-" + year;

  res.render("movie.ejs", { movieToEdit: data });
});

app.get("/:id/delete", async (req, res) => {
  let movieId = req.params.id;
  await db.query("DELETE FROM movies WHERE id = $1", [movieId]);
  res.redirect("/");
});

app.get("/:id", async (req, res) => {
  const id = req.params.id;

  const result = await db.query(
    "SELECT * FROM movies INNER JOIN notes ON movies.id = notes.movie_id WHERE movies.id = $1",
    [id]
  );
  const data = result.rows[0];
  console.log(data);

  data.genre = data.genre.split(", ");

  let d = new Date(data.date_watched);
  let month = months[d.getMonth()];
  let year = d.getFullYear();
  data.date_watched = month + " " + year;

  let cfg = {};
  let converter = new QuillDeltaToHtmlConverter(JSON.parse(data.notes), cfg);
  data.notes = converter.convert();

  res.render("movie.ejs", { movie: data });
});

app.post("/edit", async (req, res) => {
  // console.log(req.body.id);
  // console.log(req.body.flickRating);
  // console.log(req.body.dateWatched);
  // console.log(req.body.notes);

  let id = req.body.id;
  let flickRating = req.body.flickRating;
  let dateWatched = req.body.dateWatched;
  let recommended = req.body.recommended;
  dateWatched = dateWatched.slice(0, 2) + "-1" + dateWatched.slice(2);
  let notes = req.body.notes;

  const result = await db.query(
    "UPDATE notes SET flick_rating = $1, date_watched = $2, recommended = $3,  notes = $4 WHERE id = $5 RETURNING movie_id",
    [flickRating, dateWatched, recommended, notes, id]
  );

  let movieId = result.rows[0].movie_id;

  res.redirect(`/${movieId}`);
});

app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});
