using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Reflectly.Services.Migrations
{
    public partial class AddStateMachineToJournalEntry : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "state_machine_status",
                table: "JournalEntry",
                type: "text",
                nullable: true);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "state_machine_status",
                table: "JournalEntry");
        }
    }
}
