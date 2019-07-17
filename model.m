%% main model
clear,clc,close all;

re_h=100*2;
re_w=342*2;

% ´´½¨ÑµÁ·¼¯

idx_beg_class=1;
idx_end_class=3;
idx_beg_item=1;
idx_end_item=32;

k=1;
for c=idx_beg_class:idx_end_class
    for n=idx_beg_item:idx_end_item
        cc=int2str(c);
        imgName=['rice_leaf_diseases\',cc,'\',cc,' (',int2str(n),').jpg'];
        f=imread(imgName);
        [feats,seg_img]=get_features(f,re_h,re_w);
        P(k,:)=feats;
        T(k,1)=c;
        disp(['training: ',num2str(100*k/(idx_end_class-idx_beg_class+1)/(idx_end_item-idx_beg_item+1)),'%']);
        k=k+1;
    end
end

net=fitcecoc(P,T);
disp('model has trained')

idx_beg_class=1;
idx_end_class=3;
idx_beg_item=33;
idx_end_item=40;

k=1;
rci=0;
rn=0;
rc=[];
for c=idx_beg_class:idx_end_class
    for n=idx_beg_item:idx_end_item
        cc=int2str(c);
        imgName=['rice_leaf_diseases\',cc,'\',cc,' (',int2str(n),').jpg'];
        test_f=imread(imgName);
        [test_feats,test_seg_img]=get_features(test_f,re_h,re_w);
%         figure,imshow(test_seg_img),title('test_seg_img');
        r=predict(net,test_feats);
        if r==c
            rci=rci+1;
        end
        disp(['testing: ',num2str(100*k/(idx_end_class-idx_beg_class+1)/(idx_end_item-idx_beg_item+1)),'%']);
        k=k+1;
    end
    rc=[rc,rci];
    rn=rn+rci;
    rci=0;
end

acc_rate=rn/(k-1)*100;
disp(['test accuracy: ',num2str(acc_rate),'%']);

disp(['Correctly predicted class distribution: ']);
disp(['Total right/Total number: ',num2str(rn),'/',num2str(k-1)]);
disp(['Class 1: Bacterial leaf blight£¨Ï¸¾úÐÔÒ¶¿Ý²¡£©, right: ',num2str(rc(1)),'/',num2str(rn)])
disp(['Class 2: Brown spot£¨ºÖ°ß²¡£©, right: ',num2str(rc(2)),'/',num2str(rn)])
disp(['Class 3: Leaf smut£¨Ò¶ºÚËë²¡£©, right: ',num2str(rc(3)),'/',num2str(rn)])

