import express, {urlencoded} from "express"
import { port } from "./config.js"
import userRoutes from './routes/user.routes.js'
import clientRoutes from './routes/client.routes.js'
import polizaRoutes from './routes/poliza.routes.js'
import pdfReportsRoutes from './routes/pdfReports.routes.js'
import bodyParser from "body-parser"
import morgan from "morgan"
import cors from "cors"
import history from "connect-history-api-fallback"


const app = express()


//MIDDLEWARES
app.use(cors())
app.use(morgan('dev'))

app.use(express.json())
app.use(bodyParser.json())
app.use(bodyParser.urlencoded({ extended: true }))


//Routes
app.use(userRoutes)
app.use(clientRoutes)
app.use(polizaRoutes)
app.use(pdfReportsRoutes)

//MIDDELWARES FOR VUE
app.use(history())
app.use(express.static('public'))


app.get('/api', (req, res) => {
    res.send("WELCOME BITCH")
})

app.listen(port)

console.log('server on port:', port)