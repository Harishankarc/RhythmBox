const express = require('express')
const cors = require('cors')
const sqlite3 = require('sqlite3').verbose()
const multer = require('multer');
const app = express();


app.use(cors({
    origin: "http://localhost:5173",
    methods: "GET,POST,PUT,DELETE",
    credentials: true
  }))
app.use(express.json({ limit: '50mb' }));

app.use(express.urlencoded({ extended: true, limit: '50mb' }));

const storage = multer.memoryStorage();
const upload = multer({ storage, limits: { fileSize: 50 * 1024 * 1024 } });

const db = new sqlite3.Database('./database.db')

const querys = [
    `CREATE TABLE IF NOT EXISTS songs(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        album BLOB NOT NULL,
        song BLOB NOT NULL,
        artist TEXT NOT NULL,
        genere TEXT
    );`
]

db.serialize(() => {
    querys.forEach((query) => {
        db.run(query)
    })
})

//adding song list to db
app.post('/addsong', upload.fields([
    { name: 'song', maxCount: 1 },
    { name: 'album', maxCount: 1 }
]), (req, res) => {
    const title = req.body.title;
    const artist = req.body.artist;
    const songBuffer = req.files['song'][0].buffer;
    const albumBuffer = req.files['album'][0].buffer;

    const sql = `INSERT INTO songs (title, album, song, artist) VALUES (?, ?, ?,?)`;
    db.run(sql, [title, albumBuffer, songBuffer, artist], (err) => {
        if (err) {
            console.error(err.message);
            return res.status(500).json({ error: 'Failed to insert data' });
        }
        res.status(200).json({ message: 'Song added successfully!' });
    });
});

app.get('/songs',(req,res)=>{
    db.all("SELECT * FROM songs", (err, rows) => {
        if (err) return res.status(500).json({ error: err.message });
        const baseUrl = req.protocol + '://' + req.get('host');
        const formattedSongs = rows.map(song => ({
            id : song.id,
            title: song.title,
            artist: song.artist,
            song: `${baseUrl}/songs/${song.id}/song`,
            album: song.album.toString('base64'),
          }));
      
          res.json(formattedSongs);
    });
})
app.get('/songs/:id/song', (req, res) => {
    const songId = req.params.id;
    db.get("SELECT song FROM songs WHERE id = ?", [songId], (err, row) => {
      if (err || !row) return res.status(404).json({ error: 'Song not found' });
  
      res.setHeader('Content-Type', 'audio/mpeg');
      res.send(row.song);
    });
  });

app.listen(3000,'0.0.0.0', () => {
    console.log("Connected to port 4000!")
})