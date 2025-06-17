const express = require("express");
const router = express.Router();
const userController = require("../controllers/userController"); // Assurez-vous que ce contrôleur existe si vous l'utilisez pour /register
const pool = require("../config/db"); // Assurez-vous que le chemin est correct
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");

// Route de test (Optionnel - peut être supprimée ou corrigée si besoin)
// Accessible via GET /api/users/users
router.get("/users", async (req, res) => {
  try {
    // Peut-être vouliez-vous lister tous les utilisateurs ici ?
    // const [allUsers] = await pool.query("SELECT id, email, firstname, lastname, role FROM users");
    // res.json(allUsers);
    res.json({ message: "Route de test /api/users/users fonctionnelle" });
  } catch (error) {
    console.error("Erreur sur /api/users/users:", error);
    res.status(500).json({ message: error.message });
  }
});

// Route de connexion
// Accessible via POST /api/users/login
router.post("/login", async (req, res) => {
  try {
    const { email, password } = req.body;

    console.log("Tentative de connexion pour:", email);

    const [users] = await pool.query("SELECT * FROM users WHERE email = ?", [
      email,
    ]);

    if (users.length === 0) {
      console.log("Utilisateur non trouvé:", email);
      return res.status(401).json({ message: "Identifiants invalides" });
    }

    const user = users[0];

    // Vérification du mot de passe
    const validPassword = await bcrypt.compare(password, user.password);
    if (!validPassword) {
      console.log("Mot de passe invalide pour:", email);
      return res.status(401).json({ message: "Identifiants invalides" });
    }

    // Création du token JWT
    const token = jwt.sign(
      { id: user.id, email: user.email, role: user.role },
      process.env.JWT_SECRET || "your_jwt_secret", // Utilisez une variable d'environnement sécurisée !
      { expiresIn: "1h" } // Durée de validité du token
    );

    console.log("Connexion réussie pour:", email);

    // Renvoyer le token et les informations utilisateur (sans le mot de passe)
    res.json({
      token,
      user: {
        id: user.id,
        email: user.email,
        firstname: user.firstname,
        lastname: user.lastname,
        role: user.role,
        // Ajoutez d'autres champs si nécessaire, mais JAMAIS le mot de passe
      },
    });
  } catch (error) {
    console.error("Erreur lors de la connexion:", error);
    res.status(500).json({ message: "Erreur serveur lors de la connexion" });
  }
});

// Route d'inscription
// Accessible via POST /api/users/register
// Assurez-vous que userController.createUser est bien défini dans ../controllers/userController.js
router.post("/register", userController.createUser);

// --- ROUTE AJOUTÉE POUR RÉCUPÉRER UN UTILISATEUR PAR ID ---
// Accessible via GET /api/users/:userId
router.get('/:userId', async (req, res) => {
  const userId = req.params.userId;
  console.log(`[GET /api/users/:userId] Tentative de récupération de l'utilisateur ID: ${userId}`);

  // Vérifier si l'ID est un nombre valide (optionnel mais recommandé)
  if (isNaN(parseInt(userId))) {
      console.log(`[GET /api/users/:userId] ID invalide fourni: ${userId}`);
      return res.status(400).json({ message: 'ID utilisateur invalide' });
  }

  try {
    // Exécuter la requête pour trouver l'utilisateur par ID
    // Sélectionner uniquement les champs nécessaires et exclure le mot de passe
    const [users] = await pool.query(
        'SELECT id, email, firstname, lastname, role FROM users WHERE id = ?',
        [userId]
    );

    // Vérifier si un utilisateur a été trouvé
    if (users.length === 0) {
      console.log(`[GET /api/users/:userId] Utilisateur non trouvé pour ID: ${userId}`);
      // Si aucun utilisateur n'est trouvé, renvoyer une erreur 404
      return res.status(404).json({ message: 'Utilisateur non trouvé' });
    }

    // L'utilisateur trouvé est le premier élément du tableau `users`
    const user = users[0];
    console.log(`[GET /api/users/:userId] Utilisateur trouvé pour ID ${userId}:`, user);

    // Renvoyer les informations de l'utilisateur trouvé en JSON avec un statut 200 OK
    res.status(200).json(user);

  } catch (error) {
    // Gérer les erreurs potentielles (ex: problème de connexion à la BDD)
    console.error(`[GET /api/users/:userId] Erreur lors de la récupération de l'utilisateur ${userId}:`, error);
    res.status(500).json({ message: 'Erreur serveur lors de la récupération de l\'utilisateur' });
  }
});
// --- FIN DE LA ROUTE AJOUTÉE ---

module.exports = router;