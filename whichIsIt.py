#! /usr/bin/env python3
#NoGuiLinux

import pyalpm

#dump a list of pkgs installed on your arch linux system
#and determine if they belong to the official repos
#or to the AUR

class application:
    master=None
    class remote:
        master=None
        def setupRemote(self):
            handle=pyalpm.Handle('/','/var/lib/pacman')
            repos=['core','community','extra']
            db={}

            for repo in repos:
                db[repo]=handle.register_syncdb(
                        repo,
                        pyalpm.SIG_DATABASE_OPTIONAL
                        )
            sync=handle.get_syncdbs()
            return db

        def checkOfficial(self,pk,db,skip404=True):
            fail=0
            for repo in db.keys():
                pkg=db[repo].get_pkg(pk)
                if pkg != None:
                    self.master.tools.pkgAct([pkg,repo])
                    #no action for now, but down the line maybe
                else:
                    if not skip404:
                        print('{} : 404_{}'.format(pk,repo.upper()))
                    fail+=1
            if fail >= 3:
                return '{}:AUR'.format(pk)
            else:
                return '{}:OFFICIAL'.format(pk)

    class local:
        master=None
        def setupLocal(self):
            handle=pyalpm.Handle('/','/var/lib/pacman')
            db=handle.get_localdb()
            return db

        def dumpLocalPkgList(self,db):
            pkglist=[i.name for i in db.pkgcache] 
            return pkglist

    class tools:
        master=None
        def display(self,data):
            if type(data) == type(list()):
                for pk in data:
                    print(pk)
            elif type(data) == type(dict()):
                for section in data.keys():
                    print('{0}: {1}'.format(section,data[section]))
            else:
                print(pk)

        def pkgInfo(self,pkg):
        #this should only return a dict
            info={
                'arch':pkg.arch,
                'backup':pkg.backup,
                'base':pkg.base,
                'base64_sig':pkg.base64_sig,
                'builddate':pkg.builddate,
                'required_by':pkg.compute_requiredby(),
                'conflicts':pkg.conflicts,
                'db':pkg.db,
                'deltas':pkg.deltas,
                'depends':pkg.depends,
                'desc':pkg.desc,
                'download_size':pkg.download_size,
                'filename':pkg.filename,
                'files':[i[0] for i in pkg.files],
                'groups':pkg.groups,
                'has_scriptlet':pkg.has_scriptlet,
                'installdata':pkg.installdate,
                'isize':pkg.isize,
                'licenses':pkg.licenses,
                'md5sum':pkg.md5sum,
                'name':pkg.name,
                'optdepends':pkg.optdepends,
                'packager':pkg.packager,
                'provides':pkg.provides,
                'reason':pkg.reason,
                'replaces':pkg.replaces,
                'sha256sum':pkg.sha256sum,
                'size':pkg.size,
                'url':pkg.url,
                'version':pkg.version
                }
            return info

        def getInfoLocal(self,pkgName):
            db=self.master.local.setupLocal()
            info=db.get_pkg(pkgName)
            if info != None:
                info=self.pkgInfo(info)
            return info

        def getInfoRemote(self,pkgName):
            db=self.master.remote.setupRemote()
            fail=0
            info=[]
            for repo in db.keys():
                pkg=db[repo].get_pkg(pkgName)
                if pkg != None:
                    info.append(self.pkgInfo(pkg))
                else:
                    fail+=1
            if fail >= 3:
                print('{} : 404_ALL'.format(pkgName))
                return []
            else:
                return info

        def pkgAct(self,pk,skipPrint=True):
            if not skipPrint:
                if type(pk) == type(list()):
                    for i in pk:
                        print(i)
                else:
                    print(pk)


    class cmdline:
        master=None

    class advanceDisplay:
        master=None

    class void:
        master=None

    def run(self,wa):
        db=wa.remote.setupRemote()
        existant=[wa.remote.checkOfficial(i,db) for i in wa.local.dumpLocalPkgList(wa.local.setupLocal())]
        wa.tools.display(existant)
        
        '''
        lResult=wa.tools.getInfoLocal('elinks')
        wa.tools.display(lResult)
        
        rResult=wa.tools.getInfoRemote('elinks')
        for repo in rResult:
            wa.tools.display(repo)
        '''
    def assemble(self):
        wa=self.void()
        wa.master=self

        wa.tools=self.tools()
        wa.tools.master=wa

        wa.remote=self.remote()
        wa.remote.master=wa

        wa.local=self.local()
        wa.local.master=wa
    
        wa.cmdline=self.cmdline()
        wa.cmdline.master=wa

        wa.advanceDisplay=self.advanceDisplay()
        wa.advanceDisplay.master=wa

        self.run(wa)

a=application()
a.assemble()

