const express = require("express")
const notesRoutes = require("./routes/notesRoutes.js");
const { connectDB } = require("./config/db.js");
const dotenv = require("dotenv");
const rateLimiter = require("./middleware/rateLimiter.js");
const cors = require("cors")

dotenv.config();

const app = express();
app.use(cors({
    origin:"http://localhost:5173"
    })
);

connectDB().then( () => {
    app.listen(process.env.PORT, ()=> {
        console.log("Server started on port 5000");
    });
});

app.use(express.json());
app.use(rateLimiter);

app.use("/api/notes", notesRoutes);