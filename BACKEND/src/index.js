import express, {urlencoded} from "express"
import { port } from "./config.js"
import userRoutes from './routes/user.routes.js'
import morgan from "morgan"
import cors from "cors"
import fileUpload from "express-fileupload"
import history from "connect-history-api-fallback"
import path from "path"

const app = express()


//MIDDLEWARES
app.use(morgan('dev'))
app.use(express.json()) 
app.use(cors())
app.use(express.urlencoded({ extended: true }))
app.use(fileUpload({ useTempFiles: true }))
app.use(history())
app.use(express.static('public'))

//Routes
app.use(userRoutes)




app.get('/', (req, res) => {
    res.send("WELCOME BITCH")
})

app.listen(port)

console.log('server on port:', port)