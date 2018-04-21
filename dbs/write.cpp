#include "!stdafx.h"
#include "iDbs.h"

/** \brief Get ready for writing to disk
 *
 * \return void
 *
 * Set some internal fields to be written correctly.
 */
void dbs::i::Rec::on_write() {
  _01 = id;
  length2 = length;
}

bool dbs::i::is_folder(const std::string& s) {
  struct stat st;
  if (stat(s.c_str(), &st)) return false;
  if (st.st_mode | S_IFDIR) return true;
  return false;
}
