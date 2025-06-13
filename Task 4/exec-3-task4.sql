WITH RECURSIVE SubTree(EmployeeID, ManagerID, RootManagerID) AS (
    -- Базовый уровень: все сотрудники с указанием, кто для них корневой менеджер
    SELECT 
        e.EmployeeID,
        e.ManagerID,
        e.ManagerID AS RootManagerID
    FROM Employees e
    WHERE e.ManagerID IS NOT NULL

    UNION ALL

    -- Рекурсивно находим всех подчиненных и связываем с их верхним менеджером
    SELECT 
        e.EmployeeID,
        e.ManagerID,
        st.RootManagerID
    FROM Employees e
    JOIN SubTree st ON e.ManagerID = st.EmployeeID
),
-- Подсчёт задач
TaskCounts AS (
    SELECT 
        AssignedTo AS EmployeeID,
        STRING_AGG(TaskName, ', ') AS TaskNames
    FROM Tasks
    GROUP BY AssignedTo
),
-- Проекты по отделам
ProjectsByDept AS (
    SELECT 
        DepartmentID,
        STRING_AGG(ProjectName, ', ') AS ProjectNames
    FROM Projects
    GROUP BY DepartmentID
),
-- Подсчёт общего количества подчинённых (включая вложенных)
ManagerSubCounts AS (
    SELECT 
        RootManagerID AS EmployeeID,
        COUNT(*) AS TotalSubordinates
    FROM SubTree
    GROUP BY RootManagerID
)

SELECT 
    e.EmployeeID,
    e.Name AS EmployeeName,
    e.ManagerID,
    d.DepartmentName,
    r.RoleName,
    pd.ProjectNames,
    tc.TaskNames,
    ms.TotalSubordinates
FROM Employees e
JOIN Roles r ON e.RoleID = r.RoleID
LEFT JOIN Departments d ON e.DepartmentID = d.DepartmentID
LEFT JOIN ProjectsByDept pd ON e.DepartmentID = pd.DepartmentID
LEFT JOIN TaskCounts tc ON e.EmployeeID = tc.EmployeeID
JOIN ManagerSubCounts ms ON e.EmployeeID = ms.EmployeeID
WHERE r.RoleName = 'Менеджер'
ORDER BY e.Name;
