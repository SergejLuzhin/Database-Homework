WITH RECURSIVE Subordinates(EmployeeID, Name, ManagerID, DepartmentID, RoleID) AS (
    SELECT 
        e.EmployeeID,
        e.Name,
        e.ManagerID,
        e.DepartmentID,
        e.RoleID
    FROM Employees e
    WHERE e.ManagerID = 1
    UNION ALL
    SELECT 
        e.EmployeeID,
        e.Name,
        e.ManagerID,
        e.DepartmentID,
        e.RoleID
    FROM Employees e
    JOIN Subordinates ON e.ManagerID = Subordinates.EmployeeID
)
SELECT 
    s.EmployeeID,
    s.Name,
    s.ManagerID,
    d.DepartmentName,
    r.RoleName,
    (
        SELECT STRING_AGG(p.ProjectName, ', ')
        FROM Projects p
        WHERE p.DepartmentID = s.DepartmentID
    ) AS Projects,
    (
        SELECT STRING_AGG(t.TaskName, ', ')
        FROM Tasks t
        WHERE t.AssignedTo = s.EmployeeID
    ) AS Tasks
FROM Subordinates s
LEFT JOIN Departments d ON s.DepartmentID = d.DepartmentID
LEFT JOIN Roles r ON s.RoleID = r.RoleID
ORDER BY s.Name;
