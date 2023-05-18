# Simple ToDo App Workshop with GitHub Codespaces

**Based on:** [SQL Server & Azure SQL Development Containers](https://github.com/microsoft/vscode-remote-try-sqlserver)

## Setup Your Codespace

1. Click the Code menu, select the **Codespaces** tab.
2. Click **Create codespaces on main**.

More details in the [GitHub documentation](https://docs.github.com/en/free-pro-team@latest/github/developing-online-with-codespaces/creating-a-codespace#creating-a-codespace).

## Workshop Steps

1. **Create a new database using SQLCMD**

    Open the Terminal tab and execute this SQL Script to create a new database.

    ```sql
    sqlcmd -S localhost -U sa -P P@ssw0rd -d master -i 01-CreateDatabase.sql
    ```

    > Note: The SQL Server instance uses user `sa` and password `P@ssw0rd`, defined in `devcontainer.json`. This is for local development only.

2. **Create the ToDo Table**

    Run the following SQL script in the terminal to create the ToDo table:

    ```sql
    CREATE TABLE ToDo (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        Task VARCHAR(50),
        IsComplete BIT
    )
    ```

3. **Explore the database with the SQL Server extension**

    - Click on the **SQL Server** tab in the sidebar.
    - Click `mssql-container` in the SQL Server pane.
    - Enter the password provided earlier.
    - The treeview will be populated with Database items. For example, you can explore the tables or even select the rows in the `ToDo` table.

4. **Create the ToDo App**

    Use Visual Studio Code to create a new console application:

    - Right-click on the Explorer panel, then select New File.
    - Name the file `Program.cs`.
    - Write the C# code for the console app in `Program.cs`.

5. **Interact with the database**

    Update your `Program.cs` file to include a connection to the SQL Server database and provide functionality to the ToDo App. This might include displaying a list of tasks, adding new tasks, marking tasks as complete, and deleting tasks.
    
    ```csharp
    using System;
    using System.Collections.Generic;
    using System.Data.SqlClient;

    public class Program
    {
        private static string _connectionString = "Server=localhost;Database=ToDoDb;User Id=sa;Password=P@ssw0rd;";
        static void Main(string[] args)
        {
            while (true)
            {
                Console.WriteLine("1. Show all ToDo items");
                Console.WriteLine("2. Add a new ToDo item");
                Console.WriteLine("3. Exit");
                Console.WriteLine("Choose an option:");

                var option = Console.ReadLine();
                switch (option)
                {
                    case "1":
                        ShowToDoItems();
                        break;
                    case "2":
                        AddToDoItem();
                        break;
                    case "3":
                        return;
                    default:
                        Console.WriteLine("Invalid option, please try again");
                        break;
                }
            }
        }

        static void ShowToDoItems()
        {
            var toDoItems = new List<ToDoItem>();
            using (var connection = new SqlConnection(_connectionString))
            {
                connection.Open();
                using (var command = new SqlCommand("SELECT * FROM ToDo", connection))
                using (var reader = command.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        var toDoItem = new ToDoItem
                        {
                            Id = reader.GetInt32(0),
                            Task = reader.GetString(1),
                            IsComplete = reader.GetBoolean(2)
                        };

                        toDoItems.Add(toDoItem);
                    }
                }
            }

            foreach (var item in toDoItems)
            {
                Console.WriteLine($"Id: {item.Id}, Task: {item.Task}, IsComplete: {item.IsComplete}");
            }
        }

        static void AddToDoItem()
        {
            Console.WriteLine("Enter the task:");
            var task = Console.ReadLine();

            using (var connection = new SqlConnection(_connectionString))
            {
                connection.Open();
                using (var command = new SqlCommand("INSERT INTO ToDo (Task, IsComplete) VALUES (@Task, 0)", connection))
                {
                    command.Parameters.AddWithValue("@Task", task);
                    command.ExecuteNonQuery();
                }
            }

            Console.WriteLine("ToDo item added successfully");
        }
    }

    public class ToDoItem
    {
        public int Id { get; set; }
        public string Task { get; set; }
        public bool IsComplete { get; set; }
    }

    ```

6. **Run the App**

    Run the app using the Terminal in Visual Studio Code by typing `dotnet run`.

## Contributing

Contributions welcome. For most contributions, you'll need to agree to a Contributor License Agreement (CLA). For details, visit https://cla.opensource.microsoft.com.

This project follows the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).

## License

Copyright © Microsoft Corporation. All rights reserved.<br />
Licensed under the MIT License. See LICENSE in the project root.

## Trademarks

Any trademarks or logos in this project are subject to their respective policies. Microsoft trademarks or logos must follow [Microsoft's Trademark & Brand Guidelines](https://www.microsoft.com/en-us/legal/intellectualproperty/trademarks/usage/general).
