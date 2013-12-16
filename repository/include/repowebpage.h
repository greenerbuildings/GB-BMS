
#ifndef REPOWEBPAGE_H
#define REPOWEBPAGE_H 
#include <iostream>
#include <sstream>
#include <string>

class repowebpage 
{

	public:
		repowebpage(); 
		~repowebpage();
	public:
		std::string testmodule_headerpage();
		std::string testmodule_basicpage();
		std::string testmodule_tipspage();
		std::string testmodule_cf_cells_page();
		std::string testmodule_cf_celltypes_page();
		std::string testmodule_cf_cellsinside_page();
		std::string testmodule_cf_celldevicesin_page();
		std::string inventorying_headerpage();
};
#endif /* REPOWEBPAGE_H*/
