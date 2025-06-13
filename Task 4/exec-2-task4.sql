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
    JOIN Subordinates s ON e.ManagerID = s.EmployeeID
),
TaskCounts AS (
    SELECT 
        AssignedTo AS EmployeeID,
        COUNT(*) AS TotalTasks,
        STRING_AGG(TaskName, ', ') AS TaskNames
    FROM Tasks
    GROUP BY AssignedTo
),
DirectReports AS (
    SELECT 
        ManagerID,
        COUNT(*) AS TotalSubordinates
    FROM Employees
    GROUP BY ManagerID
),
ProjectsByDept AS (
    SELECT 
        DepartmentID,
        STRING_AGG(ProjectName, ', ') AS ProjectNames
    FROM Projects
    GROUP BY DepartmentID
)

SELECT 
    s.EmployeeID,
    s.Name AS EmployeeName,
    s.ManagerID,
    d.DepartmentName,
    r.RoleName,
    pd.ProjectNames,
    tc.TaskNames,
    COALESCE(tc.TotalTasks, 0) AS TotalTasks,
    COALESCE(dr.TotalSubordinates, 0) AS TotalSubordinates
FROM Subordinates s
LEFT JOIN Departments d ON s.DepartmentID = d.DepartmentID
LEFT JOIN Roles r ON s.RoleID = r.RoleID
LEFT JOIN ProjectsByDept pd ON s.DepartmentID = pd.DepartmentID
LEFT JOIN TaskCounts tc ON s.EmployeeID = tc.EmployeeID
LEFT JOIN DirectReports dr ON s.EmployeeID = dr.ManagerID
ORDER BY EmployeeName;
