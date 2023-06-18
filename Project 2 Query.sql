/*

Cleaning Data in SQL Queries

*/

SELECT *
FROM PortfolioProject..NashvilleHousing

-- Standardize Date Format

SELECT SaleDateConverted
FROM PortfolioProject..NashvilleHousing

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)

-- Populate Property Address Date

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM PortfolioProject..NashvilleHousing AS a, PortfolioProject..NashvilleHousing AS b
WHERE a.ParcelID = b.ParcelID AND a.[UniqueID ] != b.[UniqueID ] AND a.PropertyAddress IS NULL

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject..NashvilleHousing AS a, PortfolioProject..NashvilleHousing AS b
WHERE a.ParcelID = b.ParcelID AND a.[UniqueID ] != b.[UniqueID ] AND a.PropertyAddress IS NULL


-- Breaking out Address to individual columns (Address, City, State)

SELECT PropertyAddress
FROM PortfolioProject..NashvilleHousing

SELECT PARSENAME(REPLACE(PropertyAddress, ',','.'),1) AS City
FROM PortfolioProject..NashvilleHousing

SELECT PARSENAME(REPLACE(PropertyAddress, ',','.'),2) AS Address
FROM PortfolioProject..NashvilleHousing

ALTER TABLE NashvilleHousing
ADD PropertySplitAddress NVARCHAR(250)

UPDATE NashvilleHousing
SET PropertySplitAddress = PARSENAME(REPLACE(PropertyAddress, ',','.'),2)

ALTER TABLE NashvilleHousing
ADD PropertySplitCity NVARCHAR(250)

UPDATE NashvilleHousing
SET PropertySplitCity = PARSENAME(REPLACE(PropertyAddress, ',','.'),1)


SELECT OwnerAddress
FROM PortfolioProject..NashvilleHousing
WHERE OwnerAddress IS NOT NULL

SELECT PARSENAME(REPLACE(OwnerAddress, ',','.'),3) AS Address
FROM PortfolioProject..NashvilleHousing
SELECT PARSENAME(REPLACE(OwnerAddress, ',','.'),2) AS City
FROM PortfolioProject..NashvilleHousing
SELECT PARSENAME(REPLACE(OwnerAddress, ',','.'),1) AS State
FROM PortfolioProject..NashvilleHousing

ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress NVARCHAR(250)

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(PropertyAddress, ',','.'),3)

ALTER TABLE NashvilleHousing
ADD OwnerSplitCity NVARCHAR(250)

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(PropertyAddress, ',','.'),2)

ALTER TABLE NashvilleHousing
ADD OwnerSplitState NVARCHAR(250)

UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(PropertyAddress, ',','.'),1)

-- Change Y and N to Yes and No in "Sold as Vacant" field

SELECT DISTINCT SoldAsVacant
FROM PortfolioProject..NashvilleHousing

SELECT SoldAsVacant,
	CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
		 WHEN SoldAsVacant = 'N' THEN 'No'
		 ELSE SoldAsVacant
		 END
FROM PortfolioProject..NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant = 	CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
		 WHEN SoldAsVacant = 'N' THEN 'No'
		 ELSE SoldAsVacant
		 END

-- Remove Duplicates
WITH RowNumCTE AS(
SELECT *, ROW_NUMBER() OVER (PARTITION BY  ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference ORDER BY UniqueID) AS r
FROM PortfolioProject..NashvilleHousing
) 
DELETE 
FROM RowNumCTE
WHERE r >1


-- Delete Unused Columns
SELECT *
FROM PortfolioProject.dbo.NashvilleHousing


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate