/** @file cmdline.h
 *  @brief The header file for the command line option parser
 *  generated by GNU Gengetopt version 2.22.4
 *  http://www.gnu.org/software/gengetopt.
 *  DO NOT modify this file, since it can be overwritten
 *  @author GNU Gengetopt by Lorenzo Bettini */

#ifndef CMDLINE_H
#define CMDLINE_H

/* If we use autoconf.  */
#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include <stdio.h> /* for FILE */

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

#ifndef CMDLINE_PARSER_PACKAGE
/** @brief the program name (used for printing errors) */
#define CMDLINE_PARSER_PACKAGE PACKAGE
#endif

#ifndef CMDLINE_PARSER_PACKAGE_NAME
/** @brief the complete program name (used for help and version) */
#ifdef PACKAGE_NAME
#define CMDLINE_PARSER_PACKAGE_NAME PACKAGE_NAME
#else
#define CMDLINE_PARSER_PACKAGE_NAME PACKAGE
#endif
#endif

#ifndef CMDLINE_PARSER_VERSION
/** @brief the program version */
#define CMDLINE_PARSER_VERSION VERSION
#endif

/** @brief Where the command line options are stored */
struct gengetopt_args_info
{
  const char *help_help; /**< @brief Print help and exit help description.  */
  const char *version_help; /**< @brief Print version and exit help description.  */
  int forward_flag;	/**< @brief Score forward strand (default=off).  */
  const char *forward_help; /**< @brief Score forward strand help description.  */
  int reverse_flag;	/**< @brief Score reverse strand (default=off).  */
  const char *reverse_help; /**< @brief Score reverse strand help description.  */
  int both_strands_flag;	/**< @brief Score both strands (default=off).  */
  const char *both_strands_help; /**< @brief Score both strands help description.  */
  char * outfile_arg;	/**< @brief Output filename.  */
  char * outfile_orig;	/**< @brief Output filename original value given at command line.  */
  const char *outfile_help; /**< @brief Output filename help description.  */
  char * window_arg;	/**< @brief Score window.  */
  char * window_orig;	/**< @brief Score window original value given at command line.  */
  const char *window_help; /**< @brief Score window help description.  */
  float cutoff_arg;	/**< @brief Probability cutoff.  */
  char * cutoff_orig;	/**< @brief Probability cutoff original value given at command line.  */
  const char *cutoff_help; /**< @brief Probability cutoff help description.  */
  int predict_strand_flag;	/**< @brief Use strand predictor (default=off).  */
  const char *predict_strand_help; /**< @brief Use strand predictor help description.  */
  int plot_flag;	/**< @brief Generate graphical output (default=off).  */
  const char *plot_help; /**< @brief Generate graphical output help description.  */
  int dinucleotide_flag;	/**< @brief Use dinucleotide based z-scores (default) (default=off).  */
  const char *dinucleotide_help; /**< @brief Use dinucleotide based z-scores (default) help description.  */
  int mononucleotide_flag;	/**< @brief Use dinucleotide based z-scores (RNAz 1.0 model) (default=off).  */
  const char *mononucleotide_help; /**< @brief Use dinucleotide based z-scores (RNAz 1.0 model) help description.  */
  int locarnate_flag;	/**< @brief Use decision model for structural alignments (default=off).  */
  const char *locarnate_help; /**< @brief Use decision model for structural alignments help description.  */
  int no_shuffle_flag;	/**< @brief Never do explicit shuffling (default=off).  */
  const char *no_shuffle_help; /**< @brief Never do explicit shuffling help description.  */
  
  unsigned int help_given ;	/**< @brief Whether help was given.  */
  unsigned int version_given ;	/**< @brief Whether version was given.  */
  unsigned int forward_given ;	/**< @brief Whether forward was given.  */
  unsigned int reverse_given ;	/**< @brief Whether reverse was given.  */
  unsigned int both_strands_given ;	/**< @brief Whether both-strands was given.  */
  unsigned int outfile_given ;	/**< @brief Whether outfile was given.  */
  unsigned int window_given ;	/**< @brief Whether window was given.  */
  unsigned int cutoff_given ;	/**< @brief Whether cutoff was given.  */
  unsigned int predict_strand_given ;	/**< @brief Whether predict-strand was given.  */
  unsigned int plot_given ;	/**< @brief Whether plot was given.  */
  unsigned int dinucleotide_given ;	/**< @brief Whether dinucleotide was given.  */
  unsigned int mononucleotide_given ;	/**< @brief Whether mononucleotide was given.  */
  unsigned int locarnate_given ;	/**< @brief Whether locarnate was given.  */
  unsigned int no_shuffle_given ;	/**< @brief Whether no-shuffle was given.  */

  char **inputs ; /**< @brief unamed options (options without names) */
  unsigned inputs_num ; /**< @brief unamed options number */
} ;

/** @brief The additional parameters to pass to parser functions */
struct cmdline_parser_params
{
  int override; /**< @brief whether to override possibly already present options (default 0) */
  int initialize; /**< @brief whether to initialize the option structure gengetopt_args_info (default 1) */
  int check_required; /**< @brief whether to check that all required options were provided (default 1) */
  int check_ambiguity; /**< @brief whether to check for options already specified in the option structure gengetopt_args_info (default 0) */
  int print_errors; /**< @brief whether getopt_long should print an error message for a bad option (default 1) */
} ;

/** @brief the purpose string of the program */
extern const char *gengetopt_args_info_purpose;
/** @brief the usage string of the program */
extern const char *gengetopt_args_info_usage;
/** @brief all the lines making the help output */
extern const char *gengetopt_args_info_help[];

/**
 * The command line parser
 * @param argc the number of command line options
 * @param argv the command line options
 * @param args_info the structure where option information will be stored
 * @return 0 if everything went fine, NON 0 if an error took place
 */
int cmdline_parser (int argc, char **argv,
  struct gengetopt_args_info *args_info);

/**
 * The command line parser (version with additional parameters - deprecated)
 * @param argc the number of command line options
 * @param argv the command line options
 * @param args_info the structure where option information will be stored
 * @param override whether to override possibly already present options
 * @param initialize whether to initialize the option structure my_args_info
 * @param check_required whether to check that all required options were provided
 * @return 0 if everything went fine, NON 0 if an error took place
 * @deprecated use cmdline_parser_ext() instead
 */
int cmdline_parser2 (int argc, char **argv,
  struct gengetopt_args_info *args_info,
  int override, int initialize, int check_required);

/**
 * The command line parser (version with additional parameters)
 * @param argc the number of command line options
 * @param argv the command line options
 * @param args_info the structure where option information will be stored
 * @param params additional parameters for the parser
 * @return 0 if everything went fine, NON 0 if an error took place
 */
int cmdline_parser_ext (int argc, char **argv,
  struct gengetopt_args_info *args_info,
  struct cmdline_parser_params *params);

/**
 * Save the contents of the option struct into an already open FILE stream.
 * @param outfile the stream where to dump options
 * @param args_info the option struct to dump
 * @return 0 if everything went fine, NON 0 if an error took place
 */
int cmdline_parser_dump(FILE *outfile,
  struct gengetopt_args_info *args_info);

/**
 * Save the contents of the option struct into a (text) file.
 * This file can be read by the config file parser (if generated by gengetopt)
 * @param filename the file where to save
 * @param args_info the option struct to save
 * @return 0 if everything went fine, NON 0 if an error took place
 */
int cmdline_parser_file_save(const char *filename,
  struct gengetopt_args_info *args_info);

/**
 * Print the help
 */
void cmdline_parser_print_help(void);
/**
 * Print the version
 */
void cmdline_parser_print_version(void);

/**
 * Initializes all the fields a cmdline_parser_params structure 
 * to their default values
 * @param params the structure to initialize
 */
void cmdline_parser_params_init(struct cmdline_parser_params *params);

/**
 * Allocates dynamically a cmdline_parser_params structure and initializes
 * all its fields to their default values
 * @return the created and initialized cmdline_parser_params structure
 */
struct cmdline_parser_params *cmdline_parser_params_create(void);

/**
 * Initializes the passed gengetopt_args_info structure's fields
 * (also set default values for options that have a default)
 * @param args_info the structure to initialize
 */
void cmdline_parser_init (struct gengetopt_args_info *args_info);
/**
 * Deallocates the string fields of the gengetopt_args_info structure
 * (but does not deallocate the structure itself)
 * @param args_info the structure to deallocate
 */
void cmdline_parser_free (struct gengetopt_args_info *args_info);

/**
 * Checks that all the required options were specified
 * @param args_info the structure to check
 * @param prog_name the name of the program that will be used to print
 *   possible errors
 * @return
 */
int cmdline_parser_required (struct gengetopt_args_info *args_info,
  const char *prog_name);


#ifdef __cplusplus
}
#endif /* __cplusplus */
#endif /* CMDLINE_H */
