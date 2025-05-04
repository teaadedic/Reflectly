using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Reflectly.Services.Migrations
{
    public partial class Initial : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "MoodLabel",
                columns: table => new
                {
                    mood_label_id = table.Column<Guid>(type: "uniqueidentifier", nullable: false, defaultValueSql: "(newid())"),
                    label_name = table.Column<string>(type: "varchar(50)", unicode: false, maxLength: 50, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_MoodLabel", x => x.mood_label_id);
                });

            migrationBuilder.CreateTable(
                name: "Users",
                columns: table => new
                {
                    user_id = table.Column<Guid>(type: "uniqueidentifier", nullable: false, defaultValueSql: "(newid())"),
                    email = table.Column<string>(type: "varchar(255)", unicode: false, maxLength: 255, nullable: false),
                    password_hash = table.Column<string>(type: "varchar(255)", unicode: false, maxLength: 255, nullable: false),
                    password_salt = table.Column<string>(type: "varchar(255)", unicode: false, maxLength: 255, nullable: false),
                    name = table.Column<string>(type: "varchar(255)", unicode: false, maxLength: 255, nullable: false),
                    created_at = table.Column<DateTime>(type: "datetime2", nullable: true, defaultValueSql: "(getdate())"),
                    updated_at = table.Column<DateTime>(type: "datetime2", nullable: true, defaultValueSql: "(getdate())")
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Users", x => x.user_id);
                });

            migrationBuilder.CreateTable(
                name: "BreathingExerciseSession",
                columns: table => new
                {
                    session_id = table.Column<Guid>(type: "uniqueidentifier", nullable: false, defaultValueSql: "(newid())"),
                    user_id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    duration_seconds = table.Column<int>(type: "int", nullable: false),
                    timestamp = table.Column<DateTime>(type: "datetime2", nullable: true, defaultValueSql: "(getdate())")
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Breathin__69B13FDCC2276B1F", x => x.session_id);
                    table.ForeignKey(
                        name: "FK__Breathing__user___5070F446",
                        column: x => x.user_id,
                        principalTable: "Users",
                        principalColumn: "user_id");
                });

            migrationBuilder.CreateTable(
                name: "MoodEntry",
                columns: table => new
                {
                    mood_entry_id = table.Column<Guid>(type: "uniqueidentifier", nullable: false, defaultValueSql: "(newid())"),
                    user_id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    mood_emoji = table.Column<string>(type: "varchar(10)", unicode: false, maxLength: 10, nullable: false),
                    mood_text = table.Column<string>(type: "text", nullable: true),
                    timestamp = table.Column<DateTime>(type: "datetime2", nullable: true, defaultValueSql: "(getdate())")
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_MoodEntry", x => x.mood_entry_id);
                    table.ForeignKey(
                        name: "FK__MoodEntry__user___3F466844",
                        column: x => x.user_id,
                        principalTable: "Users",
                        principalColumn: "user_id");
                });

            migrationBuilder.CreateTable(
                name: "JournalEntry",
                columns: table => new
                {
                    journal_entry_id = table.Column<Guid>(type: "uniqueidentifier", nullable: false, defaultValueSql: "(newid())"),
                    user_id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    prompt_text = table.Column<string>(type: "text", nullable: false),
                    response_text = table.Column<string>(type: "text", nullable: false),
                    timestamp = table.Column<DateTime>(type: "datetime2", nullable: true, defaultValueSql: "(getdate())"),
                    linked_mood_entry_id = table.Column<Guid>(type: "uniqueidentifier", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_JournalEntry", x => x.journal_entry_id);
                    table.ForeignKey(
                        name: "FK__JournalEn__linke__44FF419A",
                        column: x => x.linked_mood_entry_id,
                        principalTable: "MoodEntry",
                        principalColumn: "mood_entry_id");
                    table.ForeignKey(
                        name: "FK__JournalEn__user___440B1D61",
                        column: x => x.user_id,
                        principalTable: "Users",
                        principalColumn: "user_id");
                });

            migrationBuilder.CreateTable(
                name: "JournalMoodLabel",
                columns: table => new
                {
                    journal_entry_id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    mood_label_id = table.Column<Guid>(type: "uniqueidentifier", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__JournalM__F743375AB6E66A98", x => new { x.journal_entry_id, x.mood_label_id });
                    table.ForeignKey(
                        name: "FK__JournalMo__journ__4AB81AF0",
                        column: x => x.journal_entry_id,
                        principalTable: "JournalEntry",
                        principalColumn: "journal_entry_id");
                    table.ForeignKey(
                        name: "FK__JournalMo__mood___4BAC3F29",
                        column: x => x.mood_label_id,
                        principalTable: "MoodLabel",
                        principalColumn: "mood_label_id");
                });

            migrationBuilder.CreateIndex(
                name: "IX_BreathingExerciseSession_user_id",
                table: "BreathingExerciseSession",
                column: "user_id");

            migrationBuilder.CreateIndex(
                name: "IX_JournalEntry_linked_mood_entry_id",
                table: "JournalEntry",
                column: "linked_mood_entry_id");

            migrationBuilder.CreateIndex(
                name: "IX_JournalEntry_user_id",
                table: "JournalEntry",
                column: "user_id");

            migrationBuilder.CreateIndex(
                name: "IX_JournalMoodLabel_mood_label_id",
                table: "JournalMoodLabel",
                column: "mood_label_id");

            migrationBuilder.CreateIndex(
                name: "IX_MoodEntry_user_id",
                table: "MoodEntry",
                column: "user_id");

            migrationBuilder.CreateIndex(
                name: "UQ__Users__AB6E6164584F9F83",
                table: "Users",
                column: "email",
                unique: true);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "BreathingExerciseSession");

            migrationBuilder.DropTable(
                name: "JournalMoodLabel");

            migrationBuilder.DropTable(
                name: "JournalEntry");

            migrationBuilder.DropTable(
                name: "MoodLabel");

            migrationBuilder.DropTable(
                name: "MoodEntry");

            migrationBuilder.DropTable(
                name: "Users");
        }
    }
}
