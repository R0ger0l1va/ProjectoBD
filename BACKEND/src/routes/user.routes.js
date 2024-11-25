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
} from "../controllers/user.controllers.js";

const router = Router();
router.get("/getSex", getSex)
router.get("/getUser/:id_usuario", getUser);
router.get('/getPais', getPais)
router.get("/GetAllUsers", getAllUsers);
router.get("/getLoginUser", getLoginUser);

router.post("/postTrabajador", postTrabajador)
router.post("/signIn", signIn);
router.post("/signUp", signUp);

router.delete("/delUsers/:id_usuario", deleteUser);

router.put("/putUsers/:id_usuario", updateUser);

export default router;
