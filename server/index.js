const express = require('express')
const cors = require('cors')
const sqlite3 = require('sqlite3').verbose()
const app = express();


app.use(cors())
app.use(express.json())

app.use(express.urlencoded({ extended: true }));

// Connect to SQLite database
const db = new sqlite3.Database('./database.db')

const querys = [
    `CREATE TABLE IF NOT EXISTS users(
        id INTEGER PRIMARY KEY,
        name VARCHAR(255),
        email VARCHAR(255),
        password VARCHAR(255)
    )`
]

querys.map(query => db.run(query))

//add users into the database
app.post('/auth/signup',(req,res)=>{
    const {name,email,password} = req.body
    const query = `INSERT INTO users(name,email,password) VALUES(?,?,?)`
    db.run(query,[name,email,password],(err)=>{
        if(err){
            return res.status(500).json({error:err.message})
        }
        return res.status(201).json({message:"User created successfully"})
    })
})

app.post('/auth/login',(req,res)=>{
    const {email,password} = req.body
    console.log(email,password)
    const query = `SELECT * FROM users WHERE email = ? AND password = ?`
    db.get(query,[email,password],(err,row)=>{
        if(err){
            return res.status(500).json({error:err.message})
        }
        if(!row){
            return res.status(401).json({error:"Invalid email or password"})
        }
        console.log(row)
        return res.status(201).json(row)
    })
})



app.listen(3000,'0.0.0.0',()=>{
    console.log("Connected to port 3000!")
})