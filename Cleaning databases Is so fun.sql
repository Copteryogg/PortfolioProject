/*

Cleaning Data in SQL Queries

*/


Select *
From PortfolioProject.dbo.NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format
Select SaleDate from PortfolioProject.dbo.NashvilleHousing

Update PortfolioProject.dbo.NashvilleHousing
Set SaleDate = Convert(Date,SaleDate)

Alter table PortfolioProject.dbo.NashvilleHousing
Add SaleDateTime Date

Update PortfolioProject.dbo.NashvilleHousing
Set SaleDateTime = Convert(Date,SaleDate)




 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

Select * from PortfolioProject.dbo.NashvilleHousing
Where PropertyAddress is null
Order by ParcelID


Select A.ParcelID, A.PropertyAddress, B.ParcelID, B.PropertyAddress, ISnull(A.PropertyAddress,B.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing A
         Join PortfolioProject.dbo.NashvilleHousing B
		 On A.ParcelID = B.ParcelID
		 And A. [UniqueID ] <> B. [UniqueID ]
		 Where A.PropertyAddress is null

Update A
Set PropertyAddress = ISnull(A.PropertyAddress,B.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing A
         Join PortfolioProject.dbo.NashvilleHousing B
		 On A.ParcelID = B.ParcelID
		 And A. [UniqueID ] <> B. [UniqueID ]
		 Where A.PropertyAddress is null







--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

Select PropertyAddress
From PortfolioProject.dbo.NashvilleHousing
--Where PropertyAddress is null
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
ADD PropertySplitAdress Nvarchar (255);

Update PortfolioProject.dbo.NashvilleHousing
Set PropertySplitAdress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
ADD PropertyCityAdress Nvarchar (255);

Update PortfolioProject.dbo.NashvilleHousing
Set PropertyCityAdress = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))


Select *
From PortfolioProject.dbo.NashvilleHousing

Select OwnerAddress From PortfolioProject.dbo.NashvilleHousing

Select
Parsename(replace(OwnerAddress,',','.'),3),
Parsename(replace(OwnerAddress,',','.'),2),
Parsename(replace(OwnerAddress,',','.'),1)
From PortfolioProject.dbo.NashvilleHousing

Alter table PortfolioProject.dbo.NashvilleHousing
Add OwnerAddressreal Nvarchar(240);

Update PortfolioProject.dbo.NashvilleHousing
set OwnerAddressreal = Parsename(replace(OwnerAddress,',','.'),3)

Alter table PortfolioProject.dbo.NashvilleHousing
Add OwnerAddressCity Nvarchar(240);

Update PortfolioProject.dbo.NashvilleHousing
set OwnerAddressCity = Parsename(replace(OwnerAddress,',','.'), 2)

Alter table PortfolioProject.dbo.NashvilleHousing
Add OwnerAddressState Nvarchar(240);

Update PortfolioProject.dbo.NashvilleHousing
set OwnerAddressState = Parsename(replace(OwnerAddress,',','.'), 1)

Select * From PortfolioProject.dbo.NashvilleHousing








--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsvacant), Count(SoldAsvacant) From PortfolioProject.dbo.NashvilleHousing
Group by SoldAsvacant
order by 2

Select *, Case when SoldAsvacant = 'Y' Then 'Yes'
               when SoldAsvacant = 'N' Then 'No'
			   Else SoldAsvacant
			   End
			   From PortfolioProject.dbo.NashvilleHousing

Update PortfolioProject.dbo.NashvilleHousing
Set SoldAsVacant = Case when SoldAsvacant = 'Y' Then 'Yes'
               when SoldAsvacant = 'N' Then 'No'
			   Else SoldAsvacant
			   End




-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

Select * from PortfolioProject.dbo.NashvilleHousing

With RowNumcte as (
Select *,row_number() Over (Partition by ParcelID, PropertyAddress,SalePrice,LegalReference Order by UniqueID) row_num
From PortfolioProject.dbo.NashvilleHousing
)

select * From RowNumcte
where row_num >1










---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns
Select * from PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP Column SaleDate,PropertyAddress,OwnerAddress, TaxDistrict














-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------

--- Importing Data using OPENROWSET and BULK INSERT	

--  More advanced and looks cooler, but have to configure server appropriately to do correctly
--  Wanted to provide this in case you wanted to try it


--sp_configure 'show advanced options', 1;
--RECONFIGURE;
--GO
--sp_configure 'Ad Hoc Distributed Queries', 1;
--RECONFIGURE;
--GO


--USE PortfolioProject 

--GO 

--EXEC master.dbo.sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0', N'AllowInProcess', 1 

--GO 

--EXEC master.dbo.sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0', N'DynamicParameters', 1 

--GO 


---- Using BULK INSERT

--USE PortfolioProject;
--GO
--BULK INSERT nashvilleHousing FROM 'C:\Temp\SQL Server Management Studio\Nashville Housing Data for Data Cleaning Project.csv'
--   WITH (
--      FIELDTERMINATOR = ',',
--      ROWTERMINATOR = '\n'
--);
--GO


---- Using OPENROWSET
--USE PortfolioProject;
--GO
--SELECT * INTO nashvilleHousing
--FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0',
--    'Excel 12.0; Database=C:\Users\alexf\OneDrive\Documents\SQL Server Management Studio\Nashville Housing Data for Data Cleaning Project.csv', [Sheet1$]);
--GO

















