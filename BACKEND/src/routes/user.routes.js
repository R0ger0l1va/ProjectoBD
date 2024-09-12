import { Router } from "express";
import {
  getUsers,
  signIn,
  signUp,
  deleteUser,
  updateUser,
} from "../controllers/user.controllers.js";

const router = Router();
router.get("/users", getUsers);

router.post("/user", signIn);
router.post("/users", signUp);
router.delete("/users", deleteUser);
router.put("/users/:id_usuario", updateUser);
export default router;
