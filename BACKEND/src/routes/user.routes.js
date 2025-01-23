import {Router} from "express";
import {
    getLoginUser,
    signIn,
    signUp,
    deleteUser,
    updateUser,
    getSex,
    getPais,
    getAllUsers,
    getUser,
    postTrabajador,
    profile,
} from "../controllers/user.controllers.js";
import { verifyToken } from "../middlewares/jwt.middleware.js";

const router = Router();
router.get("/getSex", getSex)
router.get("/getUser/:id_usuario", getUser);
router.get('/getPais', getPais)
router.get("/GetAllUsers", getAllUsers);
router.get("/getLoginUser", getLoginUser);

router.post("/postTrabajador", postTrabajador)
router.post("/signIn", signIn);
router.post("/signUp", signUp);
router.get('/profile',verifyToken,profile )

router.delete("/delUsers/:id_usuario", deleteUser);

router.put("/putUsers/:id_usuario", updateUser);

export default router;
