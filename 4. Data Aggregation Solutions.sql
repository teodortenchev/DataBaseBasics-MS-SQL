--Problem 1
SELECT COUNT(*) AS [Count]
FROM WizzardDeposits

--Problem 2
SELECT MAX(MagicWandSize) AS LongestMagicWand
FROM WizzardDeposits

--Problem 3
SELECT DepositGroup, MAX(MagicWandSize) AS LongestMagicWand
FROM WizzardDeposits
GROUP BY DepositGroup

--Problem 4

