/* ---------------------------------------------------------
   REQUETES SQL – TP HYPERDISTRIBUTION
   Auteur : Kassir TIDJANI
   --------------------------------------------------------- */

/* ============================
   1) Nombre de clients
   ============================ */
SELECT COUNT(*) AS NbClients
FROM Clients;


/* ============================
   2) Nombre de commerciaux
   ============================ */
SELECT COUNT(*) AS NbCommerciaux
FROM Commerciaux;


/* ============================
   3) Nombre de clients par commercial
   ============================ */
SELECT c.NomCommercial,
       COUNT(cl.ClientId) AS NbClients
FROM Commerciaux c
LEFT JOIN Clients cl ON cl.IcId = c.IcId
GROUP BY c.NomCommercial
ORDER BY NbClients DESC;


/* ============================
   4) Répartition géographique des clients
   ============================ */
SELECT Ville,
       COUNT(*) AS NbClients
FROM Clients
GROUP BY Ville
ORDER BY NbClients DESC;


/* =====================================================
   SECTION ANNECY
   ===================================================== */

/* ============================
   5) Liste des clients situés à Annecy
   ============================ */
SELECT *
FROM Clients
WHERE Ville = 'Annecy';


/* ============================
   6) Clients d’Annecy + commercial en charge
   ============================ */
SELECT cl.ClientId,
       cl.Enseigne,
       cl.Ville,
       c.NomCommercial
FROM Clients cl
LEFT JOIN Commerciaux c ON cl.IcId = c.IcId
WHERE cl.Ville = 'Annecy'
ORDER BY cl.ClientId;


/* ============================
   7) Factures des clients d’Annecy
   ============================ */
SELECT f.NumeroFacture,
       f.DateFacture,
       lf.ProduitId,
       lf.Quantite,
       lf.PrixVente
FROM Facture f
JOIN LigneFacture lf ON f.NumeroFacture = lf.NumeroFacture
JOIN Clients cl ON cl.ClientId = f.ClientId
WHERE cl.Ville = 'Annecy'
ORDER BY f.NumeroFacture;


/* =====================================================
   SECTION PERFORMANCE COMMERCIALE
   ===================================================== */

/* ============================
   8) CA, Achats, Marge par commercial (année 2012)
   ============================ */
SELECT c.NomCommercial,
       SUM(lf.Quantite * lf.PrixVente * 1.2) AS TotalCA,
       SUM(lf.Quantite * p.Prix) AS TotalAchat,
       SUM(lf.Quantite * lf.PrixVente * 1.2) - SUM(lf.Quantite * p.Prix) AS TotalMarge
FROM LigneFacture lf
JOIN Facture f ON lf.NumeroFacture = f.NumeroFacture
JOIN Clients cl ON cl.ClientId = f.ClientId
JOIN Commerciaux c ON c.IcId = cl.IcId
JOIN Produits p ON p.ProduitId = lf.ProduitId
WHERE YEAR(f.DateFacture) = 2012
GROUP BY c.NomCommercial
ORDER BY TotalMarge DESC;


/* ============================
   9) Meilleur commercial (évolution CA 2011 → 2012)
   ============================ */
SELECT c.NomCommercial,
       SUM(CASE WHEN YEAR(f.DateFacture) = 2011 THEN lf.Quantite * lf.PrixVente * 1.2 END) AS CA_2011,
       SUM(CASE WHEN YEAR(f.DateFacture) = 2012 THEN lf.Quantite * lf.PrixVente * 1.2 END) AS CA_2012,
       SUM(CASE WHEN YEAR(f.DateFacture) = 2012 THEN lf.Quantite * lf.PrixVente * 1.2 END)
       - SUM(CASE WHEN YEAR(f.DateFacture) = 2011 THEN lf.Quantite * lf.PrixVente * 1.2 END) AS Evolution_CA
FROM LigneFacture lf
JOIN Facture f ON lf.NumeroFacture = f.NumeroFacture
JOIN Clients cl ON cl.ClientId = f.ClientId
JOIN Commerciaux c ON c.IcId = cl.IcId
GROUP BY c.NomCommercial
ORDER BY Evolution_CA DESC;


/* ============================
   10) Quantités vendues par produit
   ============================ */
SELECT p.Designation,
       SUM(lf.Quantite) AS QuantitesVendues
FROM LigneFacture lf
JOIN Produits p ON p.ProduitId = lf.ProduitId
GROUP BY p.Designation
ORDER BY QuantitesVendues DESC;


/* =====================================================
   SECTION AUDIT CLIENT C10002
   ===================================================== */

/* ============================
   11) Toutes les factures du client C10002
   ============================ */
SELECT *
FROM Facture
WHERE ClientId = 'C10002';


/* ============================
   12) Détails des factures du client C10002
   ============================ */
SELECT lf.NumeroFacture,
       lf.ProduitId,
       f.DateFacture,
       lf.Quantite,
       lf.PrixVente
FROM LigneFacture lf
JOIN Facture f ON lf.NumeroFacture = f.NumeroFacture
WHERE f.ClientId = 'C10002'
ORDER BY lf.NumeroFacture;


/* ============================
   13) Agrégation : produits achetés par C10002
   ============================ */
SELECT p.NomProduit,
       SUM(lf.Quantite) AS TotalQuantite
FROM LigneFacture lf
JOIN Facture f ON lf.NumeroFacture = lf.NumeroFacture
JOIN Produits p ON p.ProduitId = lf.ProduitId
WHERE f.ClientId = 'C10002'
GROUP BY p.NomProduit
ORDER BY TotalQuantite DESC;


/* =====================================================
   SECTION PRODUITS IMPORTÉS
   ===================================================== */

/* ============================
   14) Produits importés (origine ≠ France)
   ============================ */
SELECT ProduitId,
       NomProduit,
       Designation,
       Origine
FROM Produits
WHERE Origine <> 'France';
``