---Standardize Date format----------


ALTER TABLE NashvilleHousingData
ALTER COLUMN SaleDate DATE

UPDATE NashvilleHousingData
SET SaleDate = CONVERT(DATE, SaleDate,104)

SELECT * FROM NashvilleHousingData


-------Populate Property Address Data----------

SELECT a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, 
ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM Portifolio_Project.dbo.NashvilleHousingData as a
JOIN Portifolio_Project.dbo.NashvilleHousingData as b
	ON a.ParcelId = b.ParcelId
	AND a.UniqueID <> b.UniqueID
	WHERE a.PropertyAddress IS NULL

	UPDATE a
	SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
	FROM Portifolio_Project.dbo.NashvilleHousingData as a
	JOIN Portifolio_Project.dbo.NashvilleHousingData as b
		ON a.ParcelId = b.ParcelId
		AND a.UniqueID <> b.UniqueID
	WHERE a.PropertyAddress IS NULL

SELECT * FROM
Portifolio_Project.dbo.NashvilleHousingData
WHERE PropertyAddress IS NULL

-----------Breaking out Adress into Individuals Columns (Address,City,State)---------

Select * FROM 
Portifolio_Project.dbo.NashvilleHousingData

Select SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as PropertySplitAddress,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as PropertySplitCity
FROM Portifolio_Project.dbo.NashvilleHousingData

ALTER TABLE Portifolio_Project.dbo.NashvilleHousingData
ADD PropertySplitAddress NVARCHAR(255)

UPDATE Portifolio_Project.dbo.NashvilleHousingData
SET PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

ALTER TABLE Portifolio_Project.dbo.NashvilleHousingData
ADD PropertySplitCity NVARCHAR(255)

UPDATE Portifolio_Project.dbo.NashvilleHousingData
SET PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))

SELECT * FROM
Portifolio_Project.dbo.NashvilleHousingData


SELECT 
PARSENAME(REPLACE(OwnerAddress,',','.'),3) as OwnerSplitAddress,
PARSENAME(REPLACE(OwnerAddress,',','.'),2)as OwnerSplitCity,
PARSENAME(REPLACE(OwnerAddress,',','.'),1)as OwnerSplitState
FROM Portifolio_Project.dbo.NashvilleHousingData
WHERE OwnerAddress is not null

ALTER TABLE Portifolio_Project.dbo.NashvilleHousingData
ADD OwnerSplitAddress NVARCHAR(128)

UPDATE Portifolio_Project.dbo.NashvilleHousingData
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

ALTER TABLE Portifolio_Project.dbo.NashvilleHousingData
ADD OwnerSplitCity NVARCHAR(128)

UPDATE Portifolio_Project.dbo.NashvilleHousingData
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

ALTER TABLE Portifolio_Project.dbo.NashvilleHousingData
ADD OwnerSplitState NVARCHAR(128)

UPDATE Portifolio_Project.dbo.NashvilleHousingData
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)


SELECT * FROM
Portifolio_Project.dbo.NashvilleHousingData

------Changing Y and N to Yes and No on "SoldAsVacant" field---------

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM Portifolio_Project.dbo.NashvilleHousingData
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant, 
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	 WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END
FROM Portifolio_Project.dbo.NashvilleHousingData

UPDATE Portifolio_Project.dbo.NashvilleHousingData
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	 WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END

------Remove Duplicates
WITH CTETABLE as (
SELECT *, ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
				 UniqueID) row_num

FROM
Portifolio_Project.dbo.NashvilleHousingData)
--ORDER BY ParcelID

DELETE
FROM CTETABLE
where row_num >1

-----------Delete unused columns

ALTER TABLE Portifolio_Project.dbo.NashvilleHousingData
DROP COLUMN PropertyAddress,OwnerAddress