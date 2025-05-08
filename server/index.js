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
    );`,
    `CREATE TABLE IF NOT EXISTS liked(
        song_id INTEGER NOT NULL,
        user_id TEXT NOT NULL,
        liked_at DATETIME DEFAULT CURRENT_TIMESTAMP
    )`,
    `CREATE TABLE IF NOT EXISTS recently(
        song_id INTEGER NOT NULL,
        user_id TEXT NOT NULL,
        seen_at DATETIME DEFAULT CURRENT_TIMESTAMP
    )`,
    `CREATE TABLE IF NOT EXISTS playlist (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        user_id TEXT NOT NULL,
        song_id INTEGER
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
    const genere = req.body.genere
    const songBuffer = req.files['song'][0].buffer;
    const albumBuffer = req.files['album'][0].buffer;

    const sql = `INSERT INTO songs (title, album, song, artist,genere) VALUES (?, ?, ?,?,?)`;
    db.run(sql, [title, albumBuffer, songBuffer, artist,genere], (err) => {
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
            genere: song.genere,
            artist: song.artist,
            song: `${baseUrl}/songs/${song.id}/song`,
            album: song.album.toString('base64')
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

app.post('/like', async (req, res) => {
    const { song_id, user_id } = req.body;
    const datetime = new Date().toISOString();

    try {
        const existing = await new Promise((resolve, reject) => {
            db.get('SELECT * FROM liked WHERE user_id = ? AND song_id = ?', [user_id, song_id], (err, row) => {
                if (err) {
                    return reject(err);
                }
                resolve(row);
            });
        });

        if (existing) {
            await new Promise((resolve, reject) => {
                db.run('DELETE FROM liked WHERE user_id = ? AND song_id = ?', [user_id, song_id], (err) => {
                    if (err) {
                        return reject(err);
                    }
                    resolve();
                });
            });

            return res.status(200).json({ message: 'Song unliked' });
        } else {
            await new Promise((resolve, reject) => {
                db.run('INSERT INTO liked (user_id, song_id, liked_at) VALUES (?, ?, ?)', [user_id, song_id, datetime], (err) => {
                    if (err) {
                        return reject(err);
                    }
                    resolve();
                });
            });

            return res.status(200).json({ message: 'Song liked' });
        }
    } catch (err) {
        console.error(err.message);
        return res.status(500).json({ error: 'Database error' });
    }
});
app.post('/recentSong',async (req,res)=>{
    const { user_id,song_id } = req.body;
    const datetime = new Date().toISOString();
    try{
        const existing = await new Promise((resolve,reject)=>{
            db.get('SELECT * FROM recently WHERE user_id = ? AND song_id = ?', [user_id, song_id], (err, row) => {
                if (err) {
                    return reject(err);
                }
                resolve(row);
            });
        })
        if(existing){
            await new Promise((resolve,reject)=>{
                db.run('UPDATE recently SET seen_at = ? WHERE user_id = ? AND song_id = ?',[datetime,user_id,song_id],(err)=>{
                    if (err) {
                        return reject(err);
                    }
                    resolve();
                })
                return res.status(200).json({ message: 'Updated the time' });
            })
        }else{
            await new Promise((resolve, reject) => {
                db.run('INSERT INTO recently (user_id, song_id, seen_at) VALUES (?, ?, ?)', [user_id, song_id, datetime], (err) => {
                    if (err) {
                        return reject(err);
                    }
                    resolve();
                })
                return res.status(200).json({ message: 'Inseted as a new song!' });
            })
        }
    }catch(e){
        console.log(e)
        return res.status(500).json({ message: 'Internal Server Error' });
    }
})

app.post('/getRecentlyPlayedSongs',(req,res)=>{
    const { user_id } = req.body
    const sql = 'SELECT songs.* FROM songs JOIN recently ON songs.id = recently.song_id WHERE recently.user_id = ? ORDER BY recently.seen_at DESC';
    db.all(sql, [user_id], (err, rows) => {
        if (err) {
            console.error(err.message);
            return res.status(500).json({ error: 'Database error' });
        }
        const formattedSongs = rows.map(song => ({
            id: song.id,
            title: song.title,
            album: song.album.toString('base64')
        }));

        res.json(formattedSongs);
    })

})


app.post('/isliked', (req, res) => {
    const { song_id, user_id } = req.body;
    const sql = `SELECT * FROM liked WHERE song_id = ? AND user_id = ?`;
    db.get(sql, [song_id, user_id], (err, row) => {
        if (err) {
            console.error(err.message);
            return res.status(500).json({ error: 'Database error' });
        }
        if (row) {
            return res.status(200).json({ liked: true });
        } else {
            return res.status(200).json({ liked: false });
        }
    });
});

app.post('/getLikedSongs',(req,res)=>{
    const { user_id } = req.body;
    const sql = 'SELECT * FROM songs WHERE id IN (SELECT song_id FROM liked WHERE user_id = ?)';
    db.all(sql, [user_id],(err,data)=>{
        if(err){
            console.error(err.message);
            return res.status(500).json({ error: 'Database error' });
        }
        const formattedSongs = data.map(song => ({
            id : song.id,
            title: song.title,
            album: song.album.toString('base64')
          }));

          res.json(formattedSongs);
    })
})

app.post('/playlistname',async (req,res)=>{
    const { user_id, playlistName } = req.body;
    const sql = `INSERT INTO playlist (name,user_id) VALUES (?,?)`;
    db.run(sql, [playlistName,user_id],(err)=>{
        if(err){
            console.error(err.message);
            return res.status(500).json({ error: 'Database error' });
        }
        return res.status(200).json({ message: 'Playlist created!' });
    })
})


app.listen(4000,'0.0.0.0', () => {
    console.log("Connected to port 4000!")
})