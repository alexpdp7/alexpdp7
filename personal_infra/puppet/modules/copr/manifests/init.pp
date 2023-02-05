define copr (
  String[1] $user,
  String[1] $project = $title,
  String[1] $dist,
) {
  file {"/etc/yum.repos.d/_copr:copr.fedorainfracloud.org:$user:$project.repo":
    content => @("REPO"/$)
        [copr:copr.fedorainfracloud.org:$user:$project]
        name=Copr repo for $project owned by $user
        baseurl=https://download.copr.fedorainfracloud.org/results/$user/$project/$dist-\$basearch/
        type=rpm-md
        skip_if_unavailable=True
        gpgcheck=1
        gpgkey=https://download.copr.fedorainfracloud.org/results/$user/$project/pubkey.gpg
        repo_gpgcheck=0
        enabled=1
        enabled_metadata=1
        | - REPO
  }
}
