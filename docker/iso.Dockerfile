# Nebula OS build crate
# We infer that there are /nebula and /nebula-work folders mounted
FROM alpine:3.7

# Mount the folder
WORKDIR /nebula-work

# Install the dependencies
RUN apk add alpine-sdk xorriso syslinux
RUN abuild-keygen -i -a

# Generate the iso
# ----------------
# Copy files to the working directory
ENV profile alpine-nebula
CMD cp /nebula/. /nebula-work/ -rf ;\
    # Install the packages
    export APK_REPOS=/nebula-package ;\
    apk del alpine-baselayout ;\
    apk add nebula-baselayout --update-cache --repository /nebula-package --allow-untrusted ;\
    apk add nebula-base --update-cache --repository /nebula-package --allow-untrusted ;\
    # Copy our profiles into the iso/ directory
    echo "Copying the profiles..." ;\
    cp /nebula/profiles/. /nebula-work/iso/ -rf ;\
    # Make an actual iso 
    echo "Building ""$profile""..." ;\
    cd iso && make PROFILE=$profile iso ;\
    # Copy iso to the root of the working directory
    echo "Copying the resulting iso(s)..." ;\
    cp /nebula-work/iso/*.iso /tmp/ ;\
    # Remove everything else
    rm /nebula-work/* -rf ;\
    cp /tmp/*.iso /nebula-work/ ;\