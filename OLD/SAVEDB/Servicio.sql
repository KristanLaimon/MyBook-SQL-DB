-- Servicio Debugging and testing
SELECT * FROM Servicio;

-- Updating
SELECT S.Nombre, R.Nombre
FROM Servicio S
         JOIN ServicioRequisito SR ON S.ID = SR.ServicioID
         JOIN Requisito R ON SR.RequisitoID = R.ID
WHERE S.ID = 0;

SELECT S.Nombre, M.Nombre
FROM ServicioMaterialNecesario SMN
         JOIN Servicio S ON SMN.ServicioID = S.ID
         JOIN Material M ON SMN.MaterialID = M.ID
WHERE S.ID = 0;


-- Creating
SELECT *
FROM Servicio S
WHERE S.ID = (SELECT MAX(S1.ID) FROM Servicio S2);

SELECT S.Nombre, R.Nombre
FROM Servicio S
         JOIN ServicioRequisito SR ON S.ID = SR.ServicioID
         JOIN Requisito R ON SR.RequisitoID = R.ID
WHERE S.ID = (SELECT MAX(S1.ID) FROM Servicio S2);

SELECT S.Nombre, M.Nombre
FROM ServicioMaterialNecesario SMN
         JOIN Servicio S ON SMN.ServicioID = S.ID
         JOIN Material M ON SMN.MaterialID = M.ID
WHERE S.ID = (SELECT MAX(S1.ID) FROM Servicio S2);
