import { Router } from "express";
import {
  getUsers,
  getUser,
  createUser,
  deleteUser,
  updateUser,
} from "../controllers/user.controllers.js";

const router = Router();
router.get("/users", getUsers);

router.get("/users/:rol", getUser);
router.post("/users", createUser);
router.delete("/users", deleteUser);
router.put("/users/:id_usuario", updateUser);
export default router;
