using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;

namespace Reflectly.Services.Database
{
    public partial class ReflectlyContext : DbContext
    {
        public ReflectlyContext()
        {
        }

        public ReflectlyContext(DbContextOptions<ReflectlyContext> options)
            : base(options)
        {
        }

        public virtual DbSet<BreathingExerciseSession> BreathingExerciseSessions { get; set; } = null!;
        public virtual DbSet<JournalEntry> JournalEntries { get; set; } = null!;
        public virtual DbSet<MoodEntry> MoodEntries { get; set; } = null!;
        public virtual DbSet<MoodLabel> MoodLabels { get; set; } = null!;
        public virtual DbSet<User> Users { get; set; } = null!;

//        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
//        {
//            if (!optionsBuilder.IsConfigured)
//            {
//#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see http://go.microsoft.com/fwlink/?LinkId=723263.
//                optionsBuilder.UseSqlServer("Server=DESKTOP-HMK2C3U\\SQLEXPRESS;Database=Reflectly;Trusted_Connection=True;");
//            }
//        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<BreathingExerciseSession>(entity =>
            {
                entity.HasKey(e => e.SessionId)
                    .HasName("PK__Breathin__69B13FDCC2276B1F");

                entity.ToTable("BreathingExerciseSession");

                entity.Property(e => e.SessionId)
                    .HasColumnName("session_id")
                    .HasDefaultValueSql("(newid())");

                entity.Property(e => e.DurationSeconds).HasColumnName("duration_seconds");

                entity.Property(e => e.Timestamp)
                    .HasColumnName("timestamp")
                    .HasDefaultValueSql("(getdate())");

                entity.Property(e => e.UserId).HasColumnName("user_id");

                entity.HasOne(d => d.User)
                    .WithMany(p => p.BreathingExerciseSessions)
                    .HasForeignKey(d => d.UserId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__Breathing__user___5070F446");
            });

            modelBuilder.Entity<JournalEntry>(entity =>
            {
                entity.ToTable("JournalEntry");

                entity.Property(e => e.JournalEntryId)
                    .HasColumnName("journal_entry_id")
                    .HasDefaultValueSql("(newid())");

                entity.Property(e => e.LinkedMoodEntryId).HasColumnName("linked_mood_entry_id");

                entity.Property(e => e.PromptText)
                    .HasColumnType("text")
                    .HasColumnName("prompt_text");

                entity.Property(e => e.ResponseText)
                    .HasColumnType("text")
                    .HasColumnName("response_text");

                entity.Property(e => e.Timestamp)
                    .HasColumnName("timestamp")
                    .HasDefaultValueSql("(getdate())");

                entity.Property(e => e.UserId).HasColumnName("user_id");

                entity.HasOne(d => d.LinkedMoodEntry)
                    .WithMany(p => p.JournalEntries)
                    .HasForeignKey(d => d.LinkedMoodEntryId)
                    .HasConstraintName("FK__JournalEn__linke__44FF419A");

                entity.HasOne(d => d.User)
                    .WithMany(p => p.JournalEntries)
                    .HasForeignKey(d => d.UserId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__JournalEn__user___440B1D61");

                entity.HasMany(d => d.MoodLabels)
                    .WithMany(p => p.JournalEntries)
                    .UsingEntity<Dictionary<string, object>>(
                        "JournalMoodLabel",
                        l => l.HasOne<MoodLabel>().WithMany().HasForeignKey("MoodLabelId").OnDelete(DeleteBehavior.ClientSetNull).HasConstraintName("FK__JournalMo__mood___4BAC3F29"),
                        r => r.HasOne<JournalEntry>().WithMany().HasForeignKey("JournalEntryId").OnDelete(DeleteBehavior.ClientSetNull).HasConstraintName("FK__JournalMo__journ__4AB81AF0"),
                        j =>
                        {
                            j.HasKey("JournalEntryId", "MoodLabelId").HasName("PK__JournalM__F743375AB6E66A98");

                            j.ToTable("JournalMoodLabel");

                            j.IndexerProperty<Guid>("JournalEntryId").HasColumnName("journal_entry_id");

                            j.IndexerProperty<Guid>("MoodLabelId").HasColumnName("mood_label_id");
                        });
            });

            modelBuilder.Entity<MoodEntry>(entity =>
            {
                entity.ToTable("MoodEntry");

                entity.Property(e => e.MoodEntryId)
                    .HasColumnName("mood_entry_id")
                    .HasDefaultValueSql("(newid())");

                entity.Property(e => e.MoodEmoji)
                    .HasMaxLength(10)
                    .IsUnicode(false)
                    .HasColumnName("mood_emoji");

                entity.Property(e => e.MoodText)
                    .HasColumnType("text")
                    .HasColumnName("mood_text");

                entity.Property(e => e.Timestamp)
                    .HasColumnName("timestamp")
                    .HasDefaultValueSql("(getdate())");

                entity.Property(e => e.UserId).HasColumnName("user_id");

                entity.HasOne(d => d.User)
                    .WithMany(p => p.MoodEntries)
                    .HasForeignKey(d => d.UserId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK__MoodEntry__user___3F466844");
            });

            modelBuilder.Entity<MoodLabel>(entity =>
            {
                entity.ToTable("MoodLabel");

                entity.Property(e => e.MoodLabelId)
                    .HasColumnName("mood_label_id")
                    .HasDefaultValueSql("(newid())");

                entity.Property(e => e.LabelName)
                    .HasMaxLength(50)
                    .IsUnicode(false)
                    .HasColumnName("label_name");
            });

            modelBuilder.Entity<User>(entity =>
            {
                entity.HasIndex(e => e.Email, "UQ__Users__AB6E6164584F9F83")
                    .IsUnique();

                entity.Property(e => e.UserId)
                    .HasColumnName("user_id")
                    .HasDefaultValueSql("(newid())");

                entity.Property(e => e.CreatedAt)
                    .HasColumnName("created_at")
                    .HasDefaultValueSql("(getdate())");

                entity.Property(e => e.Email)
                    .HasMaxLength(255)
                    .IsUnicode(false)
                    .HasColumnName("email");

                entity.Property(e => e.Name)
                    .HasMaxLength(255)
                    .IsUnicode(false)
                    .HasColumnName("name");

                entity.Property(e => e.PasswordHash)
                    .HasMaxLength(255)
                    .IsUnicode(false)
                    .HasColumnName("password_hash");

                entity.Property(e => e.PasswordSalt)
                    .HasMaxLength(255)
                    .IsUnicode(false)
                    .HasColumnName("password_salt");

                entity.Property(e => e.UpdatedAt)
                    .HasColumnName("updated_at")
                    .HasDefaultValueSql("(getdate())");
            });

            OnModelCreatingPartial(modelBuilder);
        }

        partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
    }
}
