
FROM qcdis/miniconda3-pdal AS build
COPY test-retiling-dev.user.name@domain.com-environment.yaml .
RUN conda install -c conda-forge mamba
RUN mamba env update -f test-retiling-dev.user.name@domain.com-environment.yaml
RUN conda-pack -n venv -o /tmp/env.tar && \
    mkdir /venv && cd /venv && tar xf /tmp/env.tar && \
    rm /tmp/env.tar
RUN /venv/bin/conda-unpack

FROM debian:buster AS runtime
RUN apt update -y && apt upgrade -y && apt install jq -y
COPY --from=build /venv /venv
COPY test-retiling-dev.user.name@domain.com.py .

