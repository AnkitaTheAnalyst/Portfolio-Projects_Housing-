
  
  /*

  Cleaning data in SQL Query

  */

  ----------------------------------------------------------------------------------------------------------------------------------------------------
  SELECT * 
  FROM dbo.nashville_housing_1


  --Standardize Date format


  SELECT saledateconverted,
         CONVERT(DATE,Saledate)
  FROM dbo.nashville_housing_1

  UPDATE dbo.nashville_housing_1
  SET Saledate= CONVERT(Date,Saledate)

  --If it doesn't update properly

  ALTER TABLE dbo.nashville_housing_1
  ADD Saledateconverted Date;

  UPDATE dbo.nashville_housing_1
  SET Saledateconverted = CONVERT(DATE,SALEDATE)

  Select saledateconverted
  from dbo.nashville_housing_1


  --Populated Property Address Data

  SELECT *
  FROM dbo.nashville_housing_1
  --WHERE PropertyAddress is Null
  ORDER BY ParcelID

  SELECT a.ParcelID, a.Propertyaddress, b.ParcelID, b.Propertyaddress, ISNULL(a.PropertyAddress,b.Propertyaddress)
  FROM dbo.nashville_housing_1 a
  JOIN dbo.nashville_housing_1 b
      ON a.ParcelID=b.ParcelID
      AND a.[UniqueID] <> b.[UniqueID]
  WHERE a.Propertyaddress is NULL

  UPDATE a
  SET Propertyaddress=ISNULL(a.PropertyAddress,b.Propertyaddress)
  FROM dbo.nashville_housing_1 a
  JOIN dbo.nashville_housing_1 b
     ON a.ParcelID=b.ParcelID
     AND a.[UniqueID] <> b.[UniqueID]
  WHERE a.Propertyaddress is NULL



  --Breaking out Address into Individual Columns (Address, City, State)


  SELECT Propertyaddress
  FROM dbo.nashville_housing_1



  SELECT 
  SUBSTRING(Propertyaddress,1,charindex(',',Propertyaddress)-1) as Address,
  SUBSTRING(Propertyaddress,charindex(',',Propertyaddress)+1, LEN(Propertyaddress)) as Address


  FROM dbo.nashville_housing_1


  ALTER TABLE dbo.nashville_housing_1
  Add Propertysplitaddress nvarchar(255);

  UPDATE dbo.nashville_housing_1
  SET Propertysplitaddress  = SUBSTRING(Propertyaddress,1,charindex(',',Propertyaddress)-1)



  ALTER TABLE dbo.nashville_housing_1
  Add Propertysplitcity nvarchar(255) ;

  UPDATE dbo.nashville_housing_1
  SET Propertysplitcity  = SUBSTRING(Propertyaddress,charindex(',',Propertyaddress)+1, LEN(Propertyaddress))



  SELECT *
  FROM dbo.nashville_housing_1




  SELECT OwnerAddress 
  FROM dbo.nashville_housing_1

  SELECT 
  Parsename(REPLACE(owneraddress,',','.'), 3),
  Parsename(REPLACE(owneraddress,',','.'), 2),
  Parsename(REPLACE(owneraddress,',','.'), 1)

  FROM dbo.nashville_housing_1



  ALTER TABLE dbo.nashville_housing_1
  Add Ownersplitaddress nvarchar(255);

  UPDATE dbo.nashville_housing_1
  SET Ownersplitaddress  = Parsename(REPLACE(owneraddress,',','.'), 3)



  ALTER TABLE dbo.nashville_housing_1
  Add Ownersplitcity nvarchar(255) ;

  UPDATE dbo.nashville_housing_1
  SET Ownersplitcity  = Parsename(REPLACE(owneraddress,',','.'), 2)



  ALTER TABLE dbo.nashville_housing_1
  Add Ownersplitstate nvarchar(255) ;

  UPDATE dbo.nashville_housing_1
  SET Ownersplitstate  = Parsename(REPLACE(owneraddress,',','.'), 1)

  
  SELECT *
  FROM dbo.nashville_housing_1



  --------------------------------------------------------------------------------------------------------------------------------------------------------



  SELECT Distinct SoldAsVacant
  FROM dbo.nashville_housing_1


  --------------------------------------------------------------------------------------------------------------------------------------------------------



  --Change Y and N to YES and No in 'Sold as Vacant' field



  SELECT Distinct SoldAsVacant,
         Count(SoldAsVacant)
  FROM dbo.nashville_housing_1
  GROUP BY SoldAsVacant
  ORDER BY 2





  SELECT SoldAsVacant,
  Case WHEN SoldAsVacant='Y' THEN 'YES'
       WHEN SoldAsVacant='N' THEN 'No'
	   ELSE SoldAsVacant
       END
  FROM dbo.nashville_housing_1

  UPDATE dbo.nashville_housing_1
  SET SoldAsVacant=Case WHEN SoldAsVacant='Y' THEN 'YES'
       WHEN SoldAsVacant='N' THEN 'No'
       ELSE SoldAsVacant
       END

  SELECT DISTINCT(SoldAsVacant), 
         Count(SoldAsVacant)
  FROM dbo.nashville_housing_1
  GROUP BY SoldAsVacant
  ORDER BY 2


  -------------------------------------------------------------------------------------------------------------------------------------------------------

  --Remove Duplicates


 
  With CTE As(
  SELECT *,
          ROW_NUMBER() OVER (
          PARTITION BY ParcelID,
                                Propertyaddress,
			                    Saleprice,
			                    Saledate,
			                    Legalreference
			                    ORDER BY 
			                    uniqueID
			                    ) row_num

  FROM dbo.nashville_housing_1
  )

  SELECT *
  FROM CTE
  WHERE row_num>1
  ORDER BY Propertyaddress 




  SELECT *
  FROM dbo.nashville_housing_1




  ----------------------------------------------------------------------------------------------------------------------------------------------------------

  --DELETE UNUSED COLUMNS



  SELECT *
  FROM dbo.nashville_housing_1


  ALTER TABLE dbo.nashville_housing_1
  DROP COLUMN propertyaddress, owneraddress, taxdistrict

  
  ALTER TABLE dbo.nashville_housing_1
  DROP COLUMN saledate


