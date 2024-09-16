import { Router } from "express";
import {
  getLoginUser,
  getUsers,
  signIn,
  signUp,
  deleteUser,
  updateUser,
} from "../controllers/user.controllers.js";

const router = Router();
router.get("/users", getUsers);
router.post("/signIn", signIn);
router.get("/getLoginUser", getLoginUser);
router.post("/signUp", signUp);
router.delete("/users", deleteUser);
router.put("/users/:id_usuario", updateUser);

export default router;
