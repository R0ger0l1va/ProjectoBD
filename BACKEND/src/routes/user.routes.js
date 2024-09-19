import { Router } from "express";
import {
  getLoginUser,
  signIn,
  signUp,
  deleteUser,
  updateUser,
  getSex,
  getPais,
  getAllUsers,
} from "../controllers/user.controllers.js";

const router = Router();
router.get("/getSex", getSex)
router.get('/getPais',getPais )
router.get("/GetAllUsers", getAllUsers);
router.post("/signIn", signIn);
router.get("/getLoginUser", getLoginUser);
router.post("/signUp", signUp);
router.delete("/users", deleteUser);
router.put("/users/:id_usuario", updateUser);

export default router;
