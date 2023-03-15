FROM image-registry.openshift-image-registry.svc.cluster.local:5000/images/ruby:3.2-ubi8
ADD . /opt/app-root/src
WORKDIR /opt/app-root/src
ENTRYPOINT ["/opt/app-root/src/entrypoint"]
USER root
RUN chmod +t /tmp
RUN gem install bundler 
RUN find . -type d -exec chmod 775 {} \;
RUN find . -type f -exec chmod 664 {} \;
RUN chmod 755 entrypoint
RUN mv console /bin && chmod 755 /bin/console
RUN mv envsetup /bin && chmod 755 /bin/envsetup
RUN mv runner /bin && chmod 755 /bin/runner
RUN bundle config set --local path 'vendor/bundle'
RUN bundle config set --local without 'development,test'
RUN MAKE="make -j9" bundle install --jobs 9 
RUN ln -s /opt/app-root/src/vendor/bundle/ruby/3.2.0/extensions/x86_64-linux/3.2.0/sassc-2.4.0/sassc/libsass.so /opt/app-root/src/vendor/bundle/ruby/3.2.0/gems/sassc-2.4.0/ext/libsass.so
RUN MY_HOSTNAME="localhost" bundle exec rails assets:precompile
RUN cd public && tar cvf /assets.tar assets
RUN find tmp -type d -print -exec chmod 777 {} \;
RUN chmod 777 tmp
RUN chmod 777 /opt/app-root/src/log && touch /opt/app-root/src/log/production.log && chmod 777 /opt/app-root/src/log/production.log

