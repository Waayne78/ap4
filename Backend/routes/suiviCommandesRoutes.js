const express = require('express');
const router = express.Router();
const db = require('../config/db'); // Assurez-vous que le chemin est correct

// Obtenir tous les suivis de commandes (peut être moins utile, mais gardé)
router.get('/suivi_commandes', async (req, res) => {
    try {
        const [suiviCommandes] = await db.query('SELECT * FROM suivi_commandes ORDER BY date_update DESC');
        res.json(suiviCommandes);
    } catch (error) {
        console.error("Erreur GET /suivi_commandes:", error);
        res.status(500).json({ message: error.message });
    }
});

// Obtenir un suivi de commande par son ID propre (peut être moins utile)
router.get('/suivi_commandes/:id', async (req, res) => {
    try {
        const [suiviCommande] = await db.query('SELECT * FROM suivi_commandes WHERE id = ?', [req.params.id]);
        if (suiviCommande.length === 0) {
            return res.status(404).json({ message: 'Suivi de commande non trouvé' });
        }
        res.json(suiviCommande[0]);
    } catch (error) {
        console.error(`Erreur GET /suivi_commandes/${req.params.id}:`, error);
        res.status(500).json({ message: error.message });
    }
});

// --- NOUVELLES ROUTES ---

// Obtenir tous les suivis pour une COMMANDE spécifique
// Accessible via GET /api/suivi/commandes/:commandeId/suivi (si monté avec /api/suivi)
router.get('/commandes/:commandeId/suivi', async (req, res) => {
    const commandeId = req.params.commandeId;
    console.log(`[GET /commandes/:commandeId/suivi] Récupération suivi pour commande ID: ${commandeId}`);

    if (isNaN(parseInt(commandeId))) {
        return res.status(400).json({ message: 'ID de commande invalide' });
    }

    try {
        const [suivis] = await db.query(
            'SELECT id, commande_id, status, date_update FROM suivi_commandes WHERE commande_id = ? ORDER BY date_update ASC', // Ordonner par date
            [commandeId]
        );

        if (suivis.length === 0) {
            console.log(`[GET /commandes/:commandeId/suivi] Aucun suivi trouvé pour commande ID: ${commandeId}`);
            // Renvoyer un tableau vide est souvent préférable à 404 ici
            return res.status(200).json([]);
        }

        console.log(`[GET /commandes/:commandeId/suivi] ${suivis.length} suivis trouvés pour commande ID: ${commandeId}`);
        res.status(200).json(suivis);

    } catch (error) {
        console.error(`[GET /commandes/:commandeId/suivi] Erreur pour commande ID ${commandeId}:`, error);
        res.status(500).json({ message: 'Erreur serveur lors de la récupération du suivi de commande' });
    }
});

// Ajouter une nouvelle entrée de suivi pour une commande
// Accessible via POST /api/suivi/suivi_commandes (si monté avec /api/suivi)
router.post('/suivi_commandes', async (req, res) => {
    const { commande_id, status } = req.body;
    console.log(`[POST /suivi_commandes] Ajout statut '${status}' pour commande ID: ${commande_id}`);

    // Validation simple
    if (!commande_id || !status) {
        return res.status(400).json({ message: 'Les champs commande_id et status sont requis' });
    }
    // Vous pourriez ajouter une validation pour vérifier si le statut est bien dans l'enum défini

    try {
        // Insérer la nouvelle entrée de suivi
        // La date_update est gérée automatiquement par la BDD si configurée avec CURRENT_TIMESTAMP ou NOW()
        const [result] = await db.query(
            'INSERT INTO suivi_commandes (commande_id, status) VALUES (?, ?)',
            [commande_id, status]
        );

        // Optionnel : Mettre à jour le statut dans la table `commandes` principale
        await db.query(
            'UPDATE commandes SET status = ? WHERE id = ?',
            [status, commande_id]
        );

        console.log(`[POST /suivi_commandes] Statut ajouté avec succès. ID suivi: ${result.insertId}`);
        // Renvoyer le nouvel enregistrement créé ou juste un message de succès
        res.status(201).json({
            id: result.insertId,
            commande_id: commande_id,
            status: status,
            message: 'Statut de commande mis à jour avec succès'
        });

    } catch (error) {
        console.error(`[POST /suivi_commandes] Erreur ajout statut pour commande ID ${commande_id}:`, error);
        // Vérifier les erreurs de clé étrangère (si commande_id n'existe pas)
        if (error.code === 'ER_NO_REFERENCED_ROW_2') {
             return res.status(404).json({ message: `La commande avec l'ID ${commande_id} n'existe pas.` });
        }
        res.status(500).json({ message: 'Erreur serveur lors de l\'ajout du statut de commande' });
    }
});

// --- FIN DES NOUVELLES ROUTES ---

module.exports = router;