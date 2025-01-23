import jwt from "jsonwebtoken"

export const verifyToken = (req,res,next) => {

    let token = req.headers.authorization

    if(!token){
        return res.status(401).json({ error: "Token not provided"})
    }

    
    token = token.split(" ")[1]
    console.log(token);
    

    try{
       const nombre_usuario = jwt.verify(token,process.env.JWT_SECRET )
       req.user = nombre_usuario.user
       
        next()
    }catch(error){
        console.log(error);
        return res.status(400).json({error: "Invalid token"})
        
    }

    
}