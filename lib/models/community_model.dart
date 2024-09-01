// To parse this JSON data, do
//
//     final communityModels = communityModelsFromMap(jsonString);

import 'dart:convert';

CommunityModels communityModelsFromMap(String str) => CommunityModels.fromMap(json.decode(str));

String communityModelsToMap(CommunityModels data) => json.encode(data.toMap());

class CommunityModels {
    bool? error;
    String? message;
    List<Community>? communities;

    CommunityModels({
        this.error,
        this.message,
        this.communities,
    });

    factory CommunityModels.fromMap(Map<String, dynamic> json) => CommunityModels(
        error: json["error"],
        message: json["message"],
        communities: json["communities"] == null ? [] : List<Community>.from(json["communities"]!.map((x) => Community.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "error": error,
        "message": message,
        "communities": communities == null ? [] : List<dynamic>.from(communities!.map((x) => x.toMap())),
    };
}

class Community {
    String? id;
    String? adminId;
    String? name;
    String? link;
    String? imageUrl;

    Community({
        this.id,
        this.adminId,
        this.name,
        this.link,
        this.imageUrl,
    });

    factory Community.fromMap(Map<String, dynamic> json) => Community(
        id: json["id"],
        adminId: json["adminId"],
        name: json["name"],
        link: json["link"],
        imageUrl: json["imageUrl"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "adminId": adminId,
        "name": name,
        "link": link,
        "imageUrl": imageUrl,
    };
}
