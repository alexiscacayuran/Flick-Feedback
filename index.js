import express from "express";
import bodyParser from "body-parser";
import pg from "pg";

const app = express();
const port = 3000;
const API_URL = `http://www.omdbapi.com/`;
const db = new pg.Client({
  user: "postgres",
  host: "localhost",
  database: "flick_feedback",
  password: "password",
  port: "5432",
});

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

db.connect();

app.use(bodyParser.urlencoded({ extended: true }));
app.use(express.static("public"));

app.get("/", async (req, res) => {
  const result = await db.query(
    "SELECT * FROM movies INNER JOIN notes ON movies.id = notes.movie_id"
  );
  const data = result.rows;
  data.forEach((movie) => {
    movie.genre = movie.genre.split(", ");

    let d = new Date(movie.date_watched);
    let month = months[d.getMonth()];
    let year = d.getFullYear();
    movie.date_watched = month + " " + year;
    movie.recommended = movie.recommended ? "Yes" : "No";
  });

  //console.log(data);
  res.render("index.ejs", { movies: data });
});

app.get("/add", (req, res) => {
  res.render("add.ejs");
});

app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});
