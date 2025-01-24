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
       req.user = nombre_usuario.user_id
       req.rol = nombre_usuario.user_rol
      const rolo = nombre_usuario.user_rol
       
       
       
       
        next()
    }catch(error){
        console.log(error);
        return res.status(400).json({error: "Invalid token"})
        
    }

    
}

export const verifyRoles = (allowedRoles) => {
    return (req, res, next) => {
        
        
        // Verificar si el rol del usuario está definido
        if (!req.rol) {
            return res.status(403).json({ error: "Access denied: role not provided" });
        }

        // Verificar si el rol del usuario está en la lista de roles permitidos
        if (!allowedRoles.includes(req.rol)) {
            return res.status(403).json({ error: "Access denied: insufficient permissions" });
        }

        // Si el rol es correcto, continuar con la siguiente función
        next();
    };
};

