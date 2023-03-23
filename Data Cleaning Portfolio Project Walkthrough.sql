/*

Cleaning Data in SQL Queries

*/

Select *
From PortfolioProject.dbo.NashvilleHousing

------------------------------------------------------------------------------------------------------------

-- Standardize Date Format


/* show only the saledate column from the table NashvilleHousing in PortfolioProject */
Select SaleDate
From PortfolioProject.dbo.NashvilleHousing


/* eliminate time from the saledate column and show only the date */
Select SaleDate, CONVERT(Date,SaleDate)
From PortfolioProject.dbo.NashvilleHousing


/* Update the saledate column to be date not datetime */
Update NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)


/* show the results but only show Saledate column from the table NashvilleHousing in PortfolioProject*/
Select SaleDate
From PortfolioProject.dbo.NashvilleHousing


/* add a new column to the table and name it SaleDateConverted */
ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;


/* Populate the SaleDateConverted with the converted date */
Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)


/* Show the new results */
Select SaleDateConverted, CONVERT(Date,SaleDate)
From PortfolioProject.dbo.NashvilleHousing


/* Show only the SaleDateConverted column */
Select SaleDateConverted
From PortfolioProject.dbo.NashvilleHousing

------------------------------------------------------------------------------------------------------------

-- Populate Property Address data


/* take a look at everything from the table NashvilleHousing in PortfolioProject*/
Select *
From PortfolioProject.dbo.NashvilleHousing


/* sort everthing according to ParcelID */
Select *
From PortfolioProject.dbo.NashvilleHousing
order by ParcelID


/* join the table to itself using ParcelID
where ParcelID is the same but UniqueID is different then
populate a.propertyaddress, if it is null. with b.propertyaddress */
Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
Join PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
Where a.PropertyAddress is null


/*update the table*/
Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

/* see the results */
Select *
From PortfolioProject.dbo.NashvilleHousing


--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)


/* examine only the propertyaddress from the table NashvilleHousing in PortfolioProject */
Select PropertyAddress
From PortfolioProject.dbo.NashvilleHousing


/* in propertyaddress look at the first value in the column and return all the characters preceding the , removed the , and place results in a field named Address */
/* in propertyaddress start at the , and return all the characters after the , remove the , and place the entire length of the results in a field named Address */
SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From PortfolioProject.dbo.NashvilleHousing


/* add a new column named PropertySplitAddress to the table NashvilleHousing */
ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);


/* Populate the new column PropertySplitAddress with the substring data preceding the , */
Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


/* add a new column named PropertySplitAddress to the table NashvilleHousing */
ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);


/* Populate the new column PropertySplitCity with the substring data after the , */
Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))


/* see the results */
Select *
From PortfolioProject.dbo.NashvilleHousing


/* examine only the OwnerAddress from the table NashvilleHousing in PortfolioProject */
Select OwnerAddress
From PortfolioProject.dbo.NashvilleHousing


/* look for , and replace with . return the  string in the numbered place value  */
Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From PortfolioProject.dbo.NashvilleHousing


/* add a column, name it OwnerSplitAddress with a number data type and 255 max length */
ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);


/* in the NashvilleHousing table, populate OwnerSplitAddress by parsing the 3rd portion of date in the OwnerAddress column using , as the delimiter*/
Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


/* add a column, name it OwnerSplitCity with a number data type and 255 max length */
ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);


/* in the NashvilleHousing table, populate OwnerSplitAddress by parsing the 2nd portion of date in the OwnerAddress column using , as the delimiter*/
Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)


/* add a column, name it OwnerSplitState with a number data type and 255 max length */
ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);


/* in the NashvilleHousing table, populate OwnerSplitState by parsing the 1st portion of date in the OwnerAddress column using , as the delimiter*/
Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)


/* see the results */
Select *
From PortfolioProject.dbo.NashvilleHousing



--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field

/* Select the distinctions in the SoldAsVacant column, count the number of occurrences for each and sort based on column 2 */
Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
order by 2


/* select the SoldAsVacant column, when the value is Y change to Yes and when value is N change to No. Any other values are to left as is */
Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From PortfolioProject.dbo.NashvilleHousing


/* ALTERNATIVE - select the SoldAsVacant column, when the value is Y change to Yes and when value is N change to No. Any other values are to left as is */
Update NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END


/* see the results */
Select *
From PortfolioProject.dbo.NashvilleHousing


-----------------------------------------------------------------------------------------------------------------------------------------------------------


-- Remove Duplicates

/* It's not recommended to remove data from tables. Best practices would be to copy to a table and perform removals a copy of the table. */


/* Create a temporary table named RowNumCTE
Select everything then add row number and partition the data and find duplicates in the listed field and sort based on the UniqueID column and name the column row_num */ 

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From PortfolioProject.dbo.NashvilleHousing

)

/* query from the temp table RowNumCTE 
where row_num has a value greater than 1 (occurrence is more than once) and SHOW the duplicates*/
Select *
From RowNumCTE
Where row_num > 1



/* Create a temporary table named RowNumCTE
Select everything then add row number and partition the data and find duplicates in the listed field and sort based on the UniqueID column and name the column row_num */ 

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From PortfolioProject.dbo.NashvilleHousing

)

/* query from the temp table RowNumCTE 
where row_num has a value greater than 1 (occurrence is more than once) and Delete the duplicates*/
Delete
From RowNumCTE
Where row_num > 1



-----------------------------------------------------------------------------------------------------------------------------------------------------------


--Check for more Duplicates



/* Create a temporary table named RowNumCTE
Select everything then add row number and partition the data and find duplicates in the listed field and sort based on the UniqueID column and name the column row_num */ 

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From PortfolioProject.dbo.NashvilleHousing

)

/* query from the temp table RowNumCTE 
where row_num has a value greater than 1 (occurrence is more than once) and Check for duplicates*/
Select *
From RowNumCTE
Where row_num > 1


/* see the results */
Select *
From PortfolioProject.dbo.NashvilleHousing




---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns


/* show everything */
Select *
From PortfolioProject.dbo.NashvilleHousing


/* OwnerAddress, TaxDistrict, PropertyAddress, SaleDate columns from the table NashvilleHousing */
ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate


/* show the results */
Select *
From PortfolioProject.dbo.NashvilleHousing