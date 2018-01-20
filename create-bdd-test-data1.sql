-- --------------------------------------------------------
-- Hôte :                        192.168.1.149
-- Version du serveur:           10.1.30-MariaDB-1~jessie - mariadb.org binary distribution
-- SE du serveur:                debian-linux-gnu
-- HeidiSQL Version:             9.5.0.5196
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- Export de données de la table bdd_organisaction.membresassoc : ~2 rows (environ)
/*!40000 ALTER TABLE `membresassoc` DISABLE KEYS */;
INSERT INTO `membresassoc` (`idpk`, `prenom`, `nom`, `username`, `email`, `age`) VALUES
	(1, 'John', 'Malkovich', 'jimv', 'jivm@hugestarts.com', 23),
	(2, 'Johnny', 'Depp', 'jde', 'jde-at-my@best.io', 23);
/*!40000 ALTER TABLE `membresassoc` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
