INSERT INTO Bookings (BookingID, BookingDate, TableNumber, CustomerID)
VALUES
    (1, '2022-10-10', 5, 1),
    (2, '2022-11-12', 3, 3),
    (3, '2022-10-11', 2, 2),
    (4, '2022-10-13', 2, 1);
    


DELIMITER //
CREATE PROCEDURE CheckBooking(IN bookingDate DATE, IN tableNumber INT)
BEGIN
    DECLARE tableStatus VARCHAR(20);
    
    -- Check if a booking exists for the given date and table number
    SELECT 
        CASE
            WHEN EXISTS (
                SELECT * FROM Bookings 
                WHERE BookingDate = bookingDate AND TableNumber = tableNumber
            ) THEN 'Booked'
            ELSE 'Available'
        END INTO tableStatus;
        
    -- Return the table status
    SELECT tableStatus AS TableStatus;
END //

DELIMITER ;





DELIMITER //

CREATE PROCEDURE AddValidBooking(
    IN bookingDate DATE,
    IN tableNumber INT,
    IN customerName VARCHAR(255)
)
BEGIN
    DECLARE @existingBookingCount INT;

    -- Check if the table is already booked
    SELECT COUNT(*) INTO @existingBookingCount
    FROM Bookings
    WHERE BookingDate = bookingDate AND TableNumber = tableNumber;

    -- Start a transaction
    START TRANSACTION;

    IF @existingBookingCount > 0 THEN
        -- The table is already booked, so rollback the transaction
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Table is already booked for this date.';
    ELSE
        -- The table is available, so insert the new booking
        INSERT INTO Bookings (BookingDate, TableNumber, CustomerName)
        VALUES (bookingDate, tableNumber, customerName);

        -- Commit the transaction
        COMMIT;
    END IF;
END //

DELIMITER ;

