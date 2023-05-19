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
    CREATE TABLE ToDo (Id INT IDENTITY(1,1) PRIMARY KEY, Task VARCHAR(50), IsComplete BIT);
    ```

3. **Explore the database with the SQL Server extension**

    - Click on the **SQL Server** tab in the sidebar.
    - Click `mssql-container` in the SQL Server pane.
    - Enter the password provided earlier.
    - The treeview will be populated with Database items. For example, you can explore the tables or even select the rows in the `ToDo` table.

4. **Create the ToDo App**

    Use Visual Studio Code to create a new console application:
    In this part of the workshop, you will create your application using Visual Studio Code's Terminal in GitHub Codespaces. Follow these steps:

    4.1. **Creating a new .NET Core Console Application**

    In this part of the workshop, you will create your application using Visual Studio Code's Terminal in GitHub Codespaces. Follow these steps:

    - Open the Terminal by navigating to the top menu and selecting `Terminal -> New Terminal`. Alternatively, you can use the shortcut `Ctrl + backtick (`).
    - In the Terminal, type the command `dotnet new console -n TodoApp` to create a new .NET Core console application in a new folder called "TodoApp".

    After running the command, you should see a new "TodoApp" folder in the Explorer pane on the left-hand side of the Visual Studio Code window.

    4.2. **Familiarize Yourself with the Project Structure**

    Next, you will familiarize yourself with the new console application's structure. 

    - Click on the newly created "TodoApp" folder in the Explorer pane. You'll see two files: `Program.cs` and `TodoApp.csproj`.
    - The `Program.cs` file is the starting point of your application. It includes a `Main` method which acts as the entry point of the application.
    - The `TodoApp.csproj` file is your project file. It contains information about the project and its dependencies.

    4.3. **Run the Console Application**

    After familiarizing yourself with the project structure, it's time to run the console application.

    - First, navigate into the new project directory in the Terminal by typing `cd TodoApp` and pressing `Enter`.
    - Once you're in the "TodoApp" directory (you can verify this by looking at the current path in the Terminal), type `dotnet run` and press `Enter` to run the application.

    The application will compile and execute. If everything is set up correctly, you should see the string "Hello, World!" printed in the Terminal.

    Now, to verify that you can make changes and see them reflected in the application:

    - Modify the "Hello World!" message in the `Program.cs` file.
    - Repeat the `dotnet run` command to see your changes.

    After these steps, you're ready to move on to developing your ToDo app.

5. **Interact with the database**

    Update your `Program.cs` file to include a connection to the SQL Server database and provide functionality to the ToDo App. This might include displaying a list of tasks, adding new tasks, marking tasks as complete, and deleting tasks.

    ```csharp
    // Import necessary libraries
    using System;
    using System.Collections.Generic;
    using System.Data.SqlClient;
    using Microsoft.Data.SqlClient;


    public class Program
    {
        // Database connection string
        private static string _connectionString = "Server=localhost;Database=ToDoDb;User Id=sa;Password=P@ssw0rd;TrustServerCertificate=true";
        static void Main(string[] args)
        {
            while (true)
            {
                // Show the menu to the user
                Console.WriteLine("1. Show all ToDo items");
                Console.WriteLine("2. Add a new ToDo item");
                Console.WriteLine("3. Exit");
                Console.WriteLine("Choose an option:");
                
                // Read the user's choice
                var option = Console.ReadLine();
                
                // Handle the user's choice
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

        // Function to show all To Do items
        static void ShowToDoItems()
        {
            // List to store the To Do items
            var toDoItems = new List<ToDoItem>();
            
            // Connect to the database
            using (var connection = new SqlConnection(_connectionString))
            {
                connection.Open(); // Open the connection
                
                // Create and execute the SQL command to fetch all To Do items
                using (var command = new SqlCommand("SELECT * FROM ToDo", connection))
                using (var reader = command.ExecuteReader())
                {
                
                    // Read the data and add it to the list
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

            // Print out all the To Do items
            foreach (var item in toDoItems)
            {
                Console.WriteLine($"Id: {item.Id}, Task: {item.Task}, IsComplete: {item.IsComplete}");
            }
        }
        
        // Function to add a new To Do item
        static void AddToDoItem()
        {
            // Ask the user for the task description
            Console.WriteLine("Enter the task:");
            var task = Console.ReadLine();

            // Connect to the database
            using (var connection = new SqlConnection(_connectionString))
            {
                connection.Open(); // Open the connection
                
                // Create and execute the SQL command to insert the new task
                using (var command = new SqlCommand("INSERT INTO ToDo (Task, IsComplete) VALUES (@Task, 0)", connection))
                {
                    // Add the task to the SQL command
                    command.Parameters.AddWithValue("@Task", task);
                    
                    // Execute the SQL command
                    command.ExecuteNonQuery();
                }
            }

            // Inform the user that the item was added
            Console.WriteLine("ToDo item added successfully");
        }
    }

    // Data class for a To Do item
    public class ToDoItem
    {
        // The ID of the To Do item        
        public int Id { get; set; }
        
        // The description of the To Do item
        public string Task { get; set; }
        
         // Whether the To Do item is complete or not
        public bool IsComplete { get; set; }
    }

    ```
    What happens in the previous code? Let's see some of the methods that make it:
    
    | Method                      | Explanation                                                                                                   |
    |-----------------------------|---------------------------------------------------------------------------------------------------------------|
    | `Main()`                    | The entry point of the program. It displays a menu and waits for the user to input a number.                  |
    | `ShowToDoItems()`           | This method fetches all To Do items from the database and displays them.                                      |
    | `AddToDoItem()`             | This method adds a new To Do item to the database.                                                            |
    | `ExecuteNonQuery()`         | This method in ADO.NET is used to execute statements, like INSERT, DELETE, UPDATE, and SET, which don't return any records. |
    | `Parameters.AddWithValue()` | This method adds a value to the end of the `SqlParameterCollection`. It's typically used to insert, update, or filter data in the database. |
    | `SqlConnection()`           | This method initiates a new connection to a database. The database is specified by the connection string passed as a parameter. |
    | `connection.Open()`         | This method opens a database connection with the property settings specified by the `SqlConnection.ConnectionString`. |
    | `ExecuteReader()`           | This method in ADO.NET is used to execute statements that return a result set, like SELECT. It returns a `SqlDataReader` that can be used to read the returned rows. |

    
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
